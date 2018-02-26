class ChangeContentImageToPolymorphic < ActiveRecord::Migration[5.1]
  def change
    add_column :content_images, :imageable_type, :string
    rename_column :content_images, :dashboard_id, :imageable_id

    # Make all the current content images of type Dashboard
    # (because it's the only one that exists)
    ContentImage.update_all imageable_type: 'Dashboard'
    add_index :content_images, [:imageable_type, :imageable_id]
  end
end
