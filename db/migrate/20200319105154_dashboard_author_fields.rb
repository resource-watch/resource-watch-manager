class DashboardAuthorFields < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :author_title, :string, default: ''
    add_attachment :dashboards, :author_image
  end
end
