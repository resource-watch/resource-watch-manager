# frozen_string_literal: true

module Api
  module V1
    # API class for the Subcategories Resource
    class SubcategoriesController < ApiController
      def index
        subcategories = Subcategory.all
        render json: subcategories
      end

      def show
        render json: Subcategory.friendly.find(params[:id])
      end
    end
  end
end