class AddPrivateToDashboard < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :private, :boolean, default: true
  end
end
