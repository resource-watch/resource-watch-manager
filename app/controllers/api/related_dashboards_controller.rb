class Api::RelatedDashboardsController < ApiController
  before_action :set_dashboard, only: [:show]

  def show
    render json: Dashboard.fetch_related(@dashboard, params)
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
end
