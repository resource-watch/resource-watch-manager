class RemoveOldEnvironmentFlagsFromTools < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.down do
        # set env flags based on environment value
        execute <<~SQL
          UPDATE tools
          SET production = CASE WHEN environment = '#{Environment::PRODUCTION}' THEN TRUE ELSE FALSE END,
              preproduction = CASE WHEN environment = 'preproduction' THEN TRUE ELSE FALSE END,
              staging = CASE WHEN environment = 'staging' THEN TRUE ELSE FALSE END
        SQL
      end
    end

    # environment has been populated based on the values of these columns in previous migration
    remove_column :tools, :production, :boolean, default: true
    remove_column :tools, :preproduction, :boolean, default: false
    remove_column :tools, :staging, :boolean, default: false
  end
end
