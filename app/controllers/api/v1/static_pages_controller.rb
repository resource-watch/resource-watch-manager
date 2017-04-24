# frozen_string_literal: true

module Api
  module V1
    # API class for the Static Pages Resource
    class StaticPagesController < ApiController
      include Orderable

      before_action :set_static_page, only: %w[show destroy update]

      def index
        @static_pages = StaticPage.published.order(ordering_params(params))
        paginate json: @static_pages, each_serializer: StaticPageSerializer
      end

      def show
        render json: @static_page, serializer: StaticPageSerializer
      end

      def create
        @static_page = StaticPage.new(static_page_params)
        if @static_page.save
          render json: { messages: [{ status: 201, title: 'Static Page successfully created!' }] },
                 status: 201
        else
          render json: ErrorSerializer.serialize(@static_page.errors, 422), status: 422
        end
      end

      def destroy
        if @static_page.destroy
          render json: { messages: [{ status: 201, title: 'Static Page successfully destroyed!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@static_page.errors, 422), status: 422
        end
      end

      def update
        if @static_page.update(static_page_params)
          render json: { messages: [{ status: 200, title: 'Static Page successfully updated!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@static_page.errors, 422), status: 422
        end
      end

      private

      def set_static_page
        @static_page = StaticPage.friendly.find(params[:id])
      end

      def static_page_params
        params.require(:static_page).permit(:title, :summary, :description, :content, :published)
      end
    end
  end
end
