class CreateSubcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :subcategories do |t|
      t.string :name
      t.text :description
      t.string       :slug
      t.timestamps

      t.references :category, foreign_key: true

      t.index :slug
    end
  end
end
