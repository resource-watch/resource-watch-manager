class AddTagsToDashboard < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :tags, :text
  end
end
