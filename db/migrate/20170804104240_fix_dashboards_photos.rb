class FixDashboardsPhotos < ActiveRecord::Migration[5.1]
  def change
    remove_column :dashboards, :photo
    add_attachment :dashboards, :photo
  end
end
