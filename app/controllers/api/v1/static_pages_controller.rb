# frozen_string_literal: true

module Api
  module V1
    # API class for the Static Pages Resource
    class StaticPagesController < ApiController
      def index
        static_pages = StaticPage.all
        render json: static_pages
      end

      def show
        render json: StaticPage.friendly.find(params[:id])
      end
    end
  end
end
