# frozen_string_literal: true

# == Schema Information
#
# Table name: partners
#
#  id                      :integer          not null, primary key
#  name                    :string
#  slug                    :string
#  summary                 :string
#  contact_name            :string
#  contact_email           :string
#  body                    :text
#  logo_file_name          :string
#  logo_content_type       :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  white_logo_file_name    :string
#  white_logo_content_type :string
#  white_logo_file_size    :integer
#  white_logo_updated_at   :datetime
#  icon_file_name          :string
#  icon_content_type       :string
#  icon_file_size          :integer
#  icon_updated_at         :datetime
#  published               :boolean
#  featured                :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cover_file_name         :string
#  cover_content_type      :string
#  cover_file_size         :integer
#  cover_updated_at        :datetime
#  website                 :string
#

# Model for Partner
class Partner < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i(slugged)

  validates_presence_of :name

  has_attached_file :logo,
                    styles: { medium: '320x180>', thumb: '110x60>' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :white_logo,
                    styles: { medium: '320x180>', thumb: '110x60>' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :cover,
                    styles: { large: '1600x600>', medium: '320x180>' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :icon,
                    styles: { thumb: '25x25>' },
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :logo, content_type: %r{^image\/.*}
  validates_attachment_content_type :white_logo, content_type: %r{^image\/.*}
  validates_attachment_content_type :cover, content_type: %r{^image\/.*}
  validates_attachment_content_type :icon, content_type: %r{^image\/.*}

  def self.published
    where(published: true)
  end

  def self.featured(is_featured)
    where(featured: is_featured)
  end
end
