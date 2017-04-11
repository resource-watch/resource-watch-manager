class CreateInsights < ActiveRecord::Migration[5.1]
  def change
    create_table :insights do |t|
      t.string :title
      t.text :summary
      t.text :description
      t.text :content
      t.attachment :photo
      t.boolean :published
      t.string :slug

      t.timestamps
    end
  end
end
