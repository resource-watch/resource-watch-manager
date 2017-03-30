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
  friendly_id :title, use: %i(slugged simple_i18n)

  validates_presence_of :title

  def should_generate_new_friendly_id?
    new_record?
  end
end
