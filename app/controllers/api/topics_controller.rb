# frozen_string_literal: true

class Api::TopicsController < ApiController
  before_action :set_topic, only: %i[show update destroy clone clone_dashboard]
  before_action :get_user, only: %i[index]

  def index
    topics = Topic.fetch_all(params)
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
      if duplicated_topic = @topic.duplicate(params.dig('loggedUser', 'id'))
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
      if dashboard = @topic.duplicate_dashboard(params.dig('loggedUser', 'id'))
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

  def get_user
    @user = params['loggedUser'].present? ? JSON.parse(params['loggedUser']) : nil
  end

  def set_topic
    @topic = Topic.friendly.find params[:id]
  rescue ActiveRecord::RecordNotFound
    topic = Topic.new
    topic.errors.add(:id, 'Wrong ID provided')
    render_error(topic, 404) && return
  end

  def topic_params_create
    new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    new_params = ActionController::Parameters.new(new_params)
    new_params.permit(:name, :description, :content, :published, :summary, :photo, :user_id, :private)
  rescue
    nil
  end

  def topic_params_update
    new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    new_params = ActionController::Parameters.new(new_params)
    new_params.permit(:name, :description, :content, :published, :summary, :photo, :private)
  rescue
    nil
  end
end
