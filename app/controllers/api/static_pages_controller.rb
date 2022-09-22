# frozen_string_literal: true

module Api
  # API class for the Static Pages Resource
  class StaticPagesController < ApiController
    before_action :set_static_page, only: %i[show update destroy]
    before_action :set_envs, only: %i[index]

    def index
      @static_pages = StaticPage.where(env: @envs).fetch_all(params)
      render json: @static_pages
    end

    def show
      render json: @static_page
    end

    def create
      static_page = StaticPage.new(static_page_params)
      if static_page.save
        render json: static_page, status: :created
      else
        render_error(static_page, :unprocessable_entity)
      end
    end

    def update
      if @static_page.update(static_page_params)
        render json: @static_page, status: :ok
      else
        render_error(@static_page, :unprocessable_entity)
      end
    end

    def destroy
      @static_page.destroy
      head 204
    end

    private

    def set_static_page
      @static_page = StaticPage.friendly.find params[:id]
    rescue ActiveRecord::RecordNotFound
      static_page = StaticPage.new
      static_page.errors.add(:id, 'Wrong ID provided')
      render_error(static_page, 404) && return
    end

    def static_page_params
      ParamsHelper.permit(params, :title, :summary, :description, :content, :photo, :published, :env)
    rescue
      nil
    end
  end
end
