class CreateDatasetSubcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :dataset_subcategories do |t|
      t.references :subcategory, foreign_key: true
      t.string :dataset_id
      t.timestamps
    end
  end
end
