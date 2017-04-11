# frozen_string_literal: true

# Controller for Partners
class PartnersController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?

  def index
    @partners = Partner.all
  end

  def edit
    @partner = Partner.friendly.find(params[:id])
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.save
    redirect_to partners_path
  end

  def update
    @partner = Partner.friendly.find(params[:id])
    @partner.update(partner_params)
    redirect_to partners_path
  end

  def destroy
    @partner = Partner.friendly.find(params[:id])
    if @partner.destroy
      redirect_to partners_path, notice: 'Partner successfully deleted'
    else
      redirect_to partners_path, notice: 'There was an error on deleting the partner'
    end
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :summary,
                                    :body, :contact_name, :contact_email,
                                    :website, :logo, :white_logo,
                                    :cover, :icon, :featured, :published)
  end
end
