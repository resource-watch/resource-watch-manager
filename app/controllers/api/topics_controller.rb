# frozen_string_literal: true

class Api::TopicsController < ApiController
  before_action :set_topic, only: %i[show update destroy clone]

  def index
    render json: Topic.fetch_all(params)
  end

  def show
    render json: @topic
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
      if duplicated_topic = @topic.duplicate(params[:token])
        @topic = duplicated_topic
        render json: @topic, status: :ok
      else
        render_error@topic, :unprocessable_entity
      end
    rescue
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
