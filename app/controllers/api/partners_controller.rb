class Api::PartnersController < ApiController

  def index
    partners = Partner.all.published
    partners = partners.featured(params[:featured]) if params.has_key?(:featured)
    render json: partners
  end

  def show
    render json: Partner.find(params[:id])
  end

end
