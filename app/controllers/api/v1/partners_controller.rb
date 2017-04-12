# frozen_string_literal: true

module Api
  module V1
    # API class for the Partners Resource
    class PartnersController < ApiController
      def index
        partners = Partner.all.published
        partners = partners.featured(params[:featured]) if params.key?(:featured)
        render json: partners.order('name ASC')
      end

      def show
        render json: Partner.friendly.find(params[:id])
      end
    end
  end
end
