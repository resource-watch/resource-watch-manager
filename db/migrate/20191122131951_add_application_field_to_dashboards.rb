class AddApplicationFieldToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :application, :string, array: true, null: false, default: ['rw']
  end
end
