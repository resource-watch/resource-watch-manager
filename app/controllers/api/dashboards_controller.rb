# frozen_string_literal: true

class Api::DashboardsController < ApiController
  include PaginationHelper

  before_action :set_dashboard, only: %i[show update destroy clone]
  before_action :ensure_is_admin_or_owner_manager, only: [:update, :destroy]

  before_action :get_user, only: %i[index]
  before_action :ensure_user_has_requested_apps, only: [:create, :update]
  before_action :ensure_user_can_delete_dashboard, only: :destroy
  before_action :ensure_is_manager_or_admin, only: :update
  before_action :ensure_is_admin_for_restricted_attrs, only: [:create, :update]
  before_action :ensure_user_has_at_least_rw_app, only: :create

  def index
    if params.include?('user.role') && @user&.dig('role').eql?('ADMIN')
      usersIdsByRole = UserService.usersByRole params['user.role']
      if (params.include?('user'))
        params['user'].concat usersIdsByRole if params['user'].kind_of?(Array)
        params['user'] = usersIdsByRole & [params['user']] if params['user'].kind_of?(String)
      else
        params['user'] = usersIdsByRole
      end
    end

    if (params[:page])
      page_number = params[:page][:number].to_i if params[:page][:number]
      per_page = params[:page][:size].to_i if params[:page][:size]
    end

    if per_page and per_page > 100
      render json: {errors: [{status: 400, title: "Invalid page size"}]}, status: 400
      return
    end

    dashboards = Dashboard.fetch_all(dashboard_params_get)
                   .page(page_number || 1)
                   .per_page(per_page || 10)

    dashboards_json =
      if params['includes']&.include?('user')
        user_ids = dashboards.pluck(:user_id).reduce([], :<<)
        users = UserService.users(user_ids.compact.uniq)
        UserSerializerHelper.list dashboards, users, @user&.dig('role').eql?('ADMIN')
      else
        dashboards
      end

    render json: dashboards_json, meta: {
      links: PaginationHelper.handmade_pagination_links(dashboards, params),
      'total-pages': dashboards.total_pages,
      'total-items': dashboards.total_entries,
      size: dashboards.per_page,
    }
  end

  def show
    dashboard_json =
      if params['includes']&.include?('user')
        users = UserService.users([@dashboard.user_id])
        UserSerializerHelper.element @dashboard, users
      else
        @dashboard
      end
    render json: dashboard_json
  end

  def create
    dashboard = Dashboard.new(dashboard_params_create)
    dashboard.user_id = @user.dig('id')
    if dashboard.save
      dashboard.manage_content(request.base_url)
      render json: dashboard, status: :created
    else
      render_error(dashboard, :unprocessable_entity)
    end
  end

  def update
    if @dashboard.update_attributes(dashboard_params_update)
      @dashboard.manage_content(request.base_url)
      render json: @dashboard, status: :ok
    else
      render_error(@dashboard, :unprocessable_entity)
    end
  end

  def clone
    begin
      override = dashboard_params_clone.to_h
      override[:user_id] = @user.dig('id')
      if duplicated_dashboard = @dashboard.duplicate(params.dig('loggedUser', 'id'), override)
        @dashboard = duplicated_dashboard
        render json: @dashboard, status: :ok
      else
        render_error @dashboard, :unprocessable_entity
      end
    rescue Exception => e
      @dashboard.errors['id'] << e.message
      render_error @dashboard, :internal_server_error
    end
  end

  def destroy
    @dashboard.destroy
    head 204
  end

  private

  def set_dashboard
    environments = params[:env].present? ? params[:env].split(',') : ['production']
    dashboard = Dashboard.friendly.find params[:id]

    matches = environments.map do |env|
      dashboard.public_send(env)
    end

    if matches.include?(true)
      @dashboard = dashboard
    else
      raise ActiveRecord::RecordNotFound
    end
  rescue ActiveRecord::RecordNotFound
    dashboard = Dashboard.new
    dashboard.errors.add(:id, 'Wrong ID provided')
    render_error(dashboard, 404) && return
  end

  def ensure_is_admin_or_owner_manager
    return false if @user.nil?
    return true if @user['role'].eql? "ADMIN"
    return true if @user['role'].eql? "MANAGER" and @dashboard[:user_id].eql? @user[:id]
    render json: {errors: [{status: '403', title: 'You need to be either ADMIN or MANAGER and own the dashboard to update/delete it'}]}, status: 403
  end

  def ensure_user_can_delete_dashboard
    user_apps = @user.dig('extraUserData', 'apps')
    dashboard_apps = @dashboard.application
    unless (dashboard_apps - user_apps).empty?
      render json: {errors: [{status: '403', title: 'Your user account does not have permissions to delete this dashboard'}]}, status: 403
    end
  end

  def ensure_is_admin_for_restricted_attrs
    highlighted_present = request.params.dig('data', 'attributes', 'is-highlighted').present?
    featured_present = request.params.dig('data', 'attributes', 'is-featured').present?
    return true unless highlighted_present or featured_present
    return true if (highlighted_present or featured_present) and @user[:role].eql? "ADMIN"
    render json: {errors: [{status: '403', title: 'You need to be an ADMIN to create/update the provided attribute of the dashboard'}]}, status: 403
  end

  def get_user
    @user = params['loggedUser'].present? ? JSON.parse(params['loggedUser']) : nil
  end

  def dashboard_params_get
    params.permit(:name, :published, :private, :user, :application, 'is-highlighted'.to_sym,
      'is-featured'.to_sym, user: [], :filter => [:published, :private, :user])
  end

  def dashboard_params_create
    ParamsHelper.permit(params, :name, :description, :content, :published, :summary, :photo, :private, :production,
      :preproduction, :staging, :is_highlighted, :is_featured, application:[])
  rescue
    nil
  end

  def dashboard_params_update
    ParamsHelper.permit(params, :name, :description, :content, :published, :summary, :photo, :private, :production,
      :preproduction, :staging, :is_highlighted, :is_featured, application:[])
  rescue
    nil
  end

  def dashboard_params_clone
    ParamsHelper.permit(params, :name, :description, :content, :published, :summary, :photo, :private, :production,
      :preproduction, :staging)
  rescue
    nil
  end
end
