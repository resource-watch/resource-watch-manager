# frozen_string_literal: true

module Api
  # API class for the Partners Resource
  class PartnersController < ApiController
    before_action :set_partner, only: %i[show update destroy]

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
      environments = params[:env].present? ? params[:env].split(',') : ['production']
      partner = Partner.friendly.find params[:id]

      matches = environments.map do |env|
        partner.public_send(env)
      end

      if matches.include?(true)
        @partner = partner
      else
        raise ActiveRecord::RecordNotFound
      end
    rescue ActiveRecord::RecordNotFound
      partner = Partner.new
      partner.errors.add(:id, 'Wrong ID provided')
      render_error(partner, 404) && return
    end

    def partner_params
      ParamsHelper.permit(params, :name, :contact_email, :contact_name, :body, :partner_type, :summary,
        :logo, :white_logo, :icon, :cover, :published, :featured, :website, :partner_type,
        :production, :preproduction, :staging)
    rescue
      nil
    end
  end
end
