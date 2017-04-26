# frozen_string_literal: true
# == Schema Information
#
# Table name: static_pages
#
#  id                 :integer          not null, primary key
#  title              :string           not null
#  summary            :text
#  description        :text
#  content            :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published          :boolean
#

# frozen_string_literal: true

# Static Page Model
class StaticPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i(slugged)

  before_validation :parse_image
  attr_accessor :image_base

  validates_presence_of :title

  has_attached_file :photo,
                    styles: { large: '1280x800>', medium: '320x180>', thumb: '110x60>' }

  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

  def should_generate_new_friendly_id?
    new_record?
  end

  scope :published, -> { where(published: true) }

  private

  def parse_image
    image = Paperclip.io_adapters.for(image_base)
    image.original_filename = 'file.jpg'
    self.photo = image
  end
end
