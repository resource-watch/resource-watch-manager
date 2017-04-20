# frozen_string_literal: true

module Api
  module V1
    # API class for the Static Pages Resource
    class StaticPagesController < ApiController
      before_action :set_static_page, only: %w[show destroy update]

      def index
        static_pages = StaticPage.published
        paginate json: static_pages, each_serializer: StaticPageSerializer
      end

      def show
        render json: @static_page, serializer: StaticPageSerializer
      end

      def create

      end

      def destroy

      end


      def update

      end

      private

      def set_static_page
        @static_page = StaticPage.friendly.find(params[:id])
      end

      def static_page_params
        params.require(:static_page).permit(:title)
      end
    end
  end
end
