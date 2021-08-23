class RemoveOldEnvironmentFlagsFromPartners < ActiveRecord::Migration[5.1]
  def change
    # environment has been populated based on the values of these columns in previous migration
    remove_column :partners, :production, :boolean, default: true
    remove_column :partners, :preproduction, :boolean, default: false
    remove_column :partners, :staging, :boolean, default: false
  end
end
