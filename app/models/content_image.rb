# frozen_string_literal: true
# == Schema Information
#
# Table name: content_images
#
#  id                 :bigint           not null, primary key
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :bigint
#  image_updated_at   :datetime
#  imageable_type     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  imageable_id       :integer
#
# Indexes
#
#  index_content_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

class ContentImage < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, styles: { cover: '1280x>', thumb: '110x>' }
  validates_attachment_content_type :image, content_type: %r{^image\/.*}
end
