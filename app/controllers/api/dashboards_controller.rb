class Api::DashboardsController < ApiController
  before_action :set_dashboard, only: [:show, :update, :destroy]

  def index
    render json: Dashboard.fetch_all(params)
  end

  def show
    render json: @dashboard
  end

  def create
    dashboard = Dashboard.new(dashboard_params_create)
    if dashboard.save
      render json: dashboard, status: :created
    else
      render_error(dashboard, :unprocessable_entity)
    end
  end

  def update
    if @dashboard.update_attributes(dashboard_params_update)
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
      @dashboard = Dashboard.friendly.find params[:id]
    rescue ActiveRecord::RecordNotFound
      dashboard = Dashboard.new
      dashboard.errors.add(:id, "Wrong ID provided")
      render_error(dashboard, 404) and return
    end
  end

  def dashboard_params_create
    begin
      new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      new_params = ActionController::Parameters.new(new_params)
      new_params.permit(:name, :description, :content, :published, :summary, :photo, :user_id, :private)
    rescue
      nil
    end
  end

  def dashboard_params_update
    begin
      new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      new_params = ActionController::Parameters.new(new_params)
      new_params.permit(:name, :description, :content, :published, :summary, :photo, :private)
    rescue
      nil
    end
  end
end
