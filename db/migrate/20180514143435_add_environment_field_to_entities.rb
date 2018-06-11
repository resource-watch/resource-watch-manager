class AddEnvironmentFieldToEntities < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :production, :boolean, default: true
    add_column :dashboards, :preproduction, :boolean, default: false
    add_column :dashboards, :staging, :boolean, default: false
    add_column :tools, :production, :boolean, default: true
    add_column :tools, :preproduction, :boolean, default: false
    add_column :tools, :staging, :boolean, default: false
    add_column :partners, :production, :boolean, default: true
    add_column :partners, :preproduction, :boolean, default: false
    add_column :partners, :staging, :boolean, default: false
    add_column :static_pages, :production, :boolean, default: true
    add_column :static_pages, :preproduction, :boolean, default: false
    add_column :static_pages, :staging, :boolean, default: false
  end
end
