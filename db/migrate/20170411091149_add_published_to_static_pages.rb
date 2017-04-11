class AddPublishedToStaticPages < ActiveRecord::Migration[5.1]
  def change
    add_column :static_pages, :published, :bool
  end
end
