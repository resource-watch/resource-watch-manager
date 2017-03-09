class PartnersController < ApplicationController

  before_filter :check_user_authentication

  def index
    @partners = Partner.all
  end

  def edit
    @partner = Partner.find(params[:id])
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
    @partner = Partner.find(params[:id])
    @partner.update(partner_params)
    redirect_to partners_path
  end

  private
    def partner_params
      params.require(:partner).permit(:name, :slug, :summary, :body, :contact_name, :contact_email, :featured, :published)
    end

end
