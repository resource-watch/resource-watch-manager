class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.timestamps

      t.index :slug
    end
  end
end
