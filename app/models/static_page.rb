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
#

# frozen_string_literal: true

# Static Page Model
class StaticPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i(slugged)

  validates_presence_of :title

  has_attached_file :photo,
                    styles: { medium: '320x180>', thumb: '110x60>' }

  validates_attachment_content_type :photo, content_type: %r{^image\/.*}

  def should_generate_new_friendly_id?
    new_record?
  end
end
