class AddIsHighlightedFieldToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :is_highlighted, :boolean, default: false
  end
end
