class Api::DashboardsController < ApiController
  before_action :set_dashboard, only: [:show, :update, :destroy]

  def index
    render json: Dashboard.fetch_all(params)
  end

  def show
    render json: @dashboard
  end

  def create
    dashboard = Dashboard.new(dashboard_params)
    if dashboard.save
      render json: dashboard, status: :created
    else
      render_error(dashboard, :unprocessable_entity)
    end
  end

  def update
    if @dashboard.update_attributes(dashboard_params)
      render json: @dashboard, status: :ok
    else
      render_error(@dashboard, :unprocessable_entity)
    end
  end

  def destroy
    @dashboard.destroy
    head 204
  end

  private

  def set_dashboard
    begin
      @partner = Dashboard.friendly.find params[:id]
    rescue ActiveRecord::RecordNotFound
      partner = Dashboard.new
      partner.errors.add(:id, "Wrong ID provided")
      render_error(partner, 404) and return
    end
  end

  def dashboard_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end
end
