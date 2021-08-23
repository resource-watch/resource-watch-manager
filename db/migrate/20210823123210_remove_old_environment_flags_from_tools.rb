class RemoveOldEnvironmentFlagsFromTools < ActiveRecord::Migration[5.1]
  def change
    # environment has been populated based on the values of these columns in previous migration
    remove_column :tools, :production, :boolean, default: true
    remove_column :tools, :preproduction, :boolean, default: false
    remove_column :tools, :staging, :boolean, default: false
  end
end
