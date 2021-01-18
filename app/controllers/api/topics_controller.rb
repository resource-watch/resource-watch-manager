# frozen_string_literal: true

class Api::TopicsController < ApiController
  before_action :set_topic, only: %i[show update destroy clone clone_dashboard]
  before_action :ensure_is_admin_or_owner_manager, only: :update

  before_action :ensure_user_has_requested_apps, only: [:create, :update]
  before_action :ensure_is_manager_or_admin, only: :update
  before_action :ensure_user_has_at_least_rw_app, only: :create

  def index
    topics = Topic.fetch_all(topic_params_get)
    topics_json =
      if params['includes']&.include?('user')
        user_ids = topics.pluck(:user_id).reduce([], :<<)
        users = UserService.users(user_ids.compact.uniq)
        UserSerializerHelper.list topics, users, @user&.dig('role').eql?('ADMIN')
      else
        topics
      end
    render json: topics_json
  end

  def show
    topic_json =
      if params['includes']&.include?('user')
        users = UserService.users([@topic.user_id])
        UserSerializerHelper.element @topic, users
      else
        @topic
      end
    render json: topic_json
  end

  def create
    topic = Topic.new(topic_params_create)
    if topic.save
      topic.manage_content(request.base_url)
      render json: topic, status: :created
    else
      render_error(topic, :unprocessable_entity)
    end
  end

  def update
    if @topic.update_attributes(topic_params_update)
      @topic.manage_content(request.base_url)
      render json: @topic, status: :ok
    else
      render_error(@topic, :unprocessable_entity)
    end
  end

  def clone
    begin
      if duplicated_topic = @topic.duplicate(@user.dig('id'))
        @topic = duplicated_topic
        render json: @topic, status: :ok
      else
        render_error @topic, :unprocessable_entity
      end
    rescue Exception => e
      @topic.errors['id'] << e.message
      render_error @topic, :internal_server_error
    end
  end

  def clone_dashboard
    begin
      if dashboard = @topic.duplicate_dashboard(@user.dig('id'))
        @dashboard = dashboard
        render json: @dashboard, status: :ok
      else
        render_error @dashboard, :unprocessable_entity
      end
    rescue Exception => e
      @topic.errors['id'] << e.message
      render_error @topic, :internal_server_error
    end
  end

  def destroy
    @topic.destroy
    head 204
  end

  private

  def set_topic
    @topic = Topic.friendly.find params[:id]
  rescue ActiveRecord::RecordNotFound
    topic = Topic.new
    topic.errors.add(:id, 'Wrong ID provided')
    render_error(topic, 404) && return
  end

  def ensure_is_admin_or_owner_manager
    return false if @user.nil?
    return true if @user['role'].eql? "ADMIN"
    return true if @user['role'].eql? "MANAGER" and @topic[:user_id].eql? @user['id']
    render json: {errors: [{status: '403', title: 'You need to be either ADMIN or MANAGER and own the topic to update it'}]}, status: 403
  end

  def topic_params_get
    params.permit(:name, :published, :private, :user, :application, user: [], :filter => [:published, :private, :user])
  end

  def topic_params_create
    ParamsHelper.permit(params, :name, :description, :content, :published, :summary, :photo, :user_id, :private, application:[])
  rescue
    nil
  end

  def topic_params_update
    ParamsHelper.permit(params, :name, :description, :content, :published, :summary, :photo, :private, application:[])
  rescue
    nil
  end
end
