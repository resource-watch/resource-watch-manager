class CreateTopic < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.text :content
      t.boolean :published
      t.string :summary
      t.boolean :private, default: true
      t.string :user_id

      t.timestamps
    end

    add_attachment :topics, :photo
  end
end
