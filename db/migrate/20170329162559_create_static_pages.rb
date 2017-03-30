# frozen_string_literal: true

class CreateStaticPages < ActiveRecord::Migration[5.1]
  def change
    create_table :static_pages do |t|
      t.string       :title, null: false
      t.text         :summary
      t.text         :description
      t.text         :content
      t.attachment   :photo
      t.string       :slug

      t.index :slug
      t.timestamps
    end
  end
end
