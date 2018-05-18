# frozen_string_literal: true
# == Schema Information
#
# Table name: content_images
#
#  id                 :integer          not null, primary key
#  imageable_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  imageable_type     :string
#

class ContentImage < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, styles: { cover: '1280x>', thumb: '110x>' }
  validates_attachment_content_type :image, content_type: %r{^image\/.*}
end
