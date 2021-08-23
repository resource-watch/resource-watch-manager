class AddEnvironmentToTools < ActiveRecord::Migration[5.1]
  def change
    add_column :tools, :environment, :text, default: Environment::PRODUCTION
    reversible do |dir|
      dir.up do
        # update existing records according to old env flags or apply default
        execute <<~SQL
          UPDATE tools
          SET environment = CASE
            WHEN preproduction THEN 'preproduction'
            WHEN staging THEN 'staging'
            ELSE '#{Environment::PRODUCTION}'
          END
        SQL
      end
    end
    # set NOT NULL
    change_column_null :tools, :environment, false
  end
end
