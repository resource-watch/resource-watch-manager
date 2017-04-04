class AddIndexToPartnersSlug < ActiveRecord::Migration[5.1]
  def change
    add_index :partners, :slug
  end
end
