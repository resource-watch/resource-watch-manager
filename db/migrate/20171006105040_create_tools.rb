class CreateTools < ActiveRecord::Migration[5.1]
  def change
    create_table :tools do |t|
      t.string :title
      t.string :slug
      t.string :summary
      t.string :description
      t.text :content
      t.string :url
      t.attachment :thumbnail
      t.boolean :published

      t.timestamps
    end
  end
end
