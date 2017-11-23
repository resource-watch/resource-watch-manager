class AddAttachmentToContentImage < ActiveRecord::Migration[5.1]
  def change
    add_attachment :content_images, :image 
  end
end
