class AddUserNameAndRoleToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :user_name, :string, default: nil
    add_column :dashboards, :user_role, :string, default: nil
  end
end
