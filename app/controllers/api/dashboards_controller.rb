# frozen_string_literal: true

class Api::DashboardsController < ApiController
  before_action :set_dashboard, only: %i[show update destroy]

  def index
    render json: Dashboard.fetch_all(params)
  end

  def show
    render json: @dashboard
  end

  def create
    dashboard = Dashboard.new(dashboard_params_create)
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

  def dashboard_params_create
    new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    new_params = ActionController::Parameters.new(new_params)
    new_params.permit(:name, :description, :content, :published, :summary, :photo,
                      :user_id, :private, :production, :preproduction, :staging)
  rescue
    nil
  end

  def dashboard_params_update
    new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    new_params = ActionController::Parameters.new(new_params)
    new_params.permit(:name, :description, :content, :published, :summary,
                      :photo, :private, :production, :preproduction, :staging)
  rescue
    nil
  end
end
