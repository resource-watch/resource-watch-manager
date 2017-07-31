class CreateDashboards < ActiveRecord::Migration[5.1]
  def change
    create_table :dashboards do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.text :body
      t.boolean :published

      t.timestamps
    end
  end
end
