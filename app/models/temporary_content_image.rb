# frozen_string_literal: true
# == Schema Information
#
# Table name: temporary_content_images
#
#  id                 :bigint           not null, primary key
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :bigint
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TemporaryContentImage < ApplicationRecord
  has_attached_file :image, styles: { cover: '1280x>', thumb: '110x>' }
  validates_attachment_content_type :image, content_type: %r{^image\/.*}

  def self.remove_old
    where('created_at < ?', 1.day.ago).each(&:destroy)
  end
end
