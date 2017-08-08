# frozen_string_literal: true

module Api
  # API class for the Partners Resource
  class StaticPagesController < ApiController
    before_action :set_static_, only: [:show, :update, :destroy]

    def index
      render json: StaticPage.fetch_all(params)
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
      if @static_page.update_attributes(static_page_params)
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

    def set_static_
      begin
        @static_page = StaticPage.friendly.find params[:id]
      rescue ActiveRecord::RecordNotFound
        static_page = StaticPage.new
        static_page.errors.add(:id, "Wrong ID provided")
        render_error(static_page, 404) and return
      end
    end

    def static_page_params
      begin
        new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
        new_params = ActionController::Parameters.new(new_params)
        new_params.permit(:title, :summary, :description, :content, :photo, :published)
      rescue
        nil
      end
    end
  end
end
