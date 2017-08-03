class RenameBodyToContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :dashboards, :body, :content
  end
end
