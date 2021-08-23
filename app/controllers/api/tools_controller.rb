# frozen_string_literal: true

module Api
  # API class for the Partners Resource
  class ToolsController < ApiController
    before_action :set_tool, only: %i[show update destroy]
    before_action :set_environment, only: %i[index]

    def index
      @tools = Tool.where(environment: @environments).fetch_all(params)
      render json: @tools
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
      @tool = Tool.friendly.find params[:id]
    rescue ActiveRecord::RecordNotFound
      tool = Tool.new
      tool.errors.add(:id, 'Wrong ID provided')
      render_error(tool, 404) && return
    end

    def tool_params
      ParamsHelper.permit(params, :title, :slug, :summary, :description, :content,
        :thumbnail, :url, :published, :environment)
    rescue
      nil
    end
  end
end
