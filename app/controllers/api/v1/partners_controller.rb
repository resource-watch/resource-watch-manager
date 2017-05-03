# frozen_string_literal: true

module Api
  module V1
    # API class for the Partners Resource
    class PartnersController < ApiController
      def index
        partners = Partner.all.published
        partners = partners.featured(params[:featured]) if params.key?(:featured)
        partners = partners.filtered_by_type(params[:type]) if params.key?(:type)
        render json: partners.order('name ASC')
      end

      def show
        render json: Partner.friendly.find(params[:id])
      end

      def create
        @partner = Partner.new(partner_params)
        if @partner.save
          render json: { messages: [{ status: 201, title: 'Partner successfully created!' }] },
                 status: 201
        else
          render json: ErrorSerializer.serialize(@partner.errors, 422), status: 422
        end
      end

      def update
        if @partner.update(partner_params)
          render json: { messages: [{ status: 200, title: 'Partner successfully updated!' }] },
                 status: 200
        else
          render json: ErrorSSerializer.serialize(@partner.errors, 422), status: 422
        end
      end

      def destroy
        if @partner.destroy
          render json: { messages: [{ status: 201, title: 'Partner successfully destroyed!' }] },
                 status: 200
        else
          render json: ErrorSerializer.serialize(@partner.errors, 422), status: 422
        end
      end

      private

      def partner_params
        params.require(:partner).permit(:name, :summary, :contact_email, :contact_name,
                                        :body, :published, :featured, :website,
                                        :logo_base, :white_logo_base, :cover_base, :icon_base)
      end
    end
  end
end
