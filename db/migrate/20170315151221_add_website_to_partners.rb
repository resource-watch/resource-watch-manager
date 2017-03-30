# frozen_string_literal: true

class AddWebsiteToPartners < ActiveRecord::Migration[5.0]
  def change
    add_column :partners, :website, :string
  end
end
