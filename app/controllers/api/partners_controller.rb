# frozen_string_literal: true

module Api
  # API class for the Partners Resource
  class PartnersController < ApiController
    before_action :set_partner, only: [:show, :update, :destroy]

    def index
      render json: Partner.fetch_all(params)
    end

    def show
      render json: @partner
    end

    def create
      partner = Partner.new(partner_params)
      if partner.save
        render json: partner, status: :created
      else
        render_error(partner, :unprocessable_entity)
      end
    end

    def update
      if @partner.update_attributes(partner_params)
        render json: @partner, status: :ok
      else
        render_error(@partner, :unprocessable_entity)
      end
    end

    def destroy
      @partner.destroy
      head 204
    end

    private

    def set_partner
      begin
        @partner = Partner.friendly.find params[:id]
      rescue ActiveRecord::RecordNotFound
        partner = Partner.new
        partner.errors.add(:id, "Wrong ID provided")
        render_error(partner, 404) and return
      end
    end

    def partner_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end
  end
end
