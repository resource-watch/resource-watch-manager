# frozen_string_literal: true

module Api
  # API class for the Partners Resource
  class ToolsController < ApiController
    before_action :set_tool, only: %i[show update destroy]

    def index
      render json: Tool.fetch_all(params)
    end

    def show
      render json: @tool
    end

    def create
      tool = Tool.new(tool_params)
      if tool.save
        render json: tool, status: :created
      else
        render_error(tool, :unprocessable_entity)
      end
    end

    def update
      if @tool.update_attributes(tool_params)
        render json: @tool, status: :ok
      else
        render_error(@tool, :unprocessable_entity)
      end
    end

    def destroy
      @tool.destroy
      head 204
    end

    private

    def set_tool
      environments = params[:env].present? ? params[:env].split(',') : ['production']
      tool = Tool.friendly.find params[:id]

      matches = environments.map do |env|
        tool.public_send(env)
      end

      if matches.include?(true)
        @tool = tool
      else
        raise ActiveRecord::RecordNotFound
      end
    rescue ActiveRecord::RecordNotFound
      tool = Tool.new
      tool.errors.add(:id, 'Wrong ID provided')
      render_error(tool, 404) && return
    end

    def tool_params
      new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      new_params = ActionController::Parameters.new(new_params)
      new_params.permit(:title, :slug, :summary, :description, :content,
                        :thumbnail, :url, :published, :production, :preproduction, :staging)
    rescue
      nil
    end
  end
end
