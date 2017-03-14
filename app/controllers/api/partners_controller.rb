class Api::PartnersController < ApiController

  def index
    render json: Partner.all.published
  end

end
