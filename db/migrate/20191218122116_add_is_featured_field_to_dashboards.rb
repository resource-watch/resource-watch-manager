class AddIsFeaturedFieldToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :is_featured, :boolean, default: false
  end
end