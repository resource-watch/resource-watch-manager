# == Schema Information
#
# Table name: apps
#
#  id                     :integer          not null, primary key
#  name                   :string
#  description            :text
#  body                   :text
#  technical_details      :text
#  author                 :string
#  web_url                :string
#  ios_url                :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class App < ApplicationRecord

  before_validation :parse_image
  attr_accessor :image_base

  validates_presence_of :name

  has_attached_file :thumbnail,
                    styles: { thumb: '320x180>' }
  validates_attachment_content_type :thumbnail, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :thumbnail

  private

  def parse_image
    image = Paperclip.io_adapters.for(image_base)
    image.original_filename = 'file.jpg'
    self.thumbnail = image
  end
end
