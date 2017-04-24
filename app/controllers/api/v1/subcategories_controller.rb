# frozen_string_literal: true

module Api
  module V1
    # API class for the Subcategories Resource
    class SubcategoriesController < ApiController
      def index
        subcategories = Subcategory.all
        subcategories.each(&:build_datasets) if include_datasets?
        render json: subcategories
      end

      def show
        subcategory = Subcategory.friendly.find(params[:id])
        subcategory.build_datasets if include_datasets?
        render json: subcategory, include: ['datasets']
      end

      private

      def include_datasets?
        subcategories_params[:datasets] == 'true'
      end

      def subcategories_params
        params.permit(:datasets, :id)
      end

    end
  end
end