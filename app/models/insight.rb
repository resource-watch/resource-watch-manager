# frozen_string_literal: true
# == Schema Information
#
# Table name: insights
#
#  id                 :integer          not null, primary key
#  title              :string
#  summary            :text
#  description        :text
#  content            :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  published          :boolean
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# frozen_string_literal: true

# Insight Model
class Insight < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged]

  validates_presence_of :title

  has_attached_file :photo,
                    styles: { medium: '320x180>', thumb: '110x60>' }
  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

  def should_generate_new_friendly_id?
    new_record?
  end

  scope :published, -> { where(published: true) }
end
