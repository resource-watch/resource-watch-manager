# frozen_string_literal: true

class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :slug
      t.string :summary
      t.string :contact_name
      t.string :contact_email
      t.text :body
      t.attachment :logo
      t.attachment :white_logo
      t.attachment :icon
      t.boolean :published, default: false
      t.boolean :featured, default: false

      t.timestamps
    end
  end
end
