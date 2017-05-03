class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :name
      t.text :description
      t.text :body
      t.text :technical_details
      t.string :author
      t.string :web_url
      t.string :ios_url
      t.attachment :thumbnail

      t.timestamps
    end
  end
end
