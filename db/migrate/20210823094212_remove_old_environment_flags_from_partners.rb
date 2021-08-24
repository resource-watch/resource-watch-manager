class RemoveOldEnvironmentFlagsFromPartners < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.down do
        # set env flags based on environment value
        execute <<~SQL
          UPDATE partners
          SET production = CASE WHEN environment = '#{Environment::PRODUCTION}' THEN TRUE ELSE FALSE END,
              preproduction = CASE WHEN environment = 'preproduction' THEN TRUE ELSE FALSE END,
              staging = CASE WHEN environment = 'staging' THEN TRUE ELSE FALSE END
        SQL
      end
    end

    # environment has been populated based on the values of these columns in previous migration
    remove_column :partners, :production, :boolean, default: true
    remove_column :partners, :preproduction, :boolean, default: false
    remove_column :partners, :staging, :boolean, default: false
  end
end
