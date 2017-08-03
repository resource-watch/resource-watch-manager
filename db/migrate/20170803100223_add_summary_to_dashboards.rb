class AddSummaryToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :summary, :string
  end
end
