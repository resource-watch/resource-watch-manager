# frozen_string_literal: true

module Api
  module V1
    # API class for the Categories Resource
    class CategoriesController < ApiController
      def index
        categories = Category.all
        render json: categories
      end

      def show
        render json: Category.friendly.find(categories_params)
      end

      private

      def include_datasets?
        categories_params[:datasets] == 'true'
      end

      def categories_params
        params.permit(:datasets, :id)
      end
    end
  end
end