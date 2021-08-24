class RenameEnvironmentToEnv < ActiveRecord::Migration[5.1]
  def change
    rename_column :faqs, :environment, :env
    rename_column :partners, :environment, :env
    rename_column :tools, :environment, :env
    rename_column :static_pages, :environment, :env
    rename_column :dashboards, :environment, :env
  end
end
