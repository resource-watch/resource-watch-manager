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
#  partner_type            :string
#  production              :boolean          default(TRUE)
#  preproduction           :boolean          default(FALSE)
#  staging                 :boolean          default(FALSE)
#

# Model for Partner
class Partner < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  attr_accessor :logo_base, :white_logo_base, :cover_base, :icon_base

  before_validation do
    parse_image('logo', logo_base)
    parse_image('white_logo', white_logo_base)
    parse_image('cover', cover_base)
    parse_image('icon', icon_base)
  end

  validates_presence_of :name

  has_attached_file :logo,
                    styles: { medium: '320x>', thumb: '110x>' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :white_logo,
                    styles: { medium: '320x>', thumb: '110x>' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :cover,
                    styles: { large: '1600x>', medium: '320x>' },
                    default_url: '/images/:style/missing.png'
  has_attached_file :icon,
                    styles: { thumb: '25x>' },
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :logo, content_type: %r{^image\/.*}
  validates_attachment_content_type :white_logo, content_type: %r{^image\/.*}
  validates_attachment_content_type :cover, content_type: %r{^image\/.*}
  validates_attachment_content_type :icon, content_type: %r{^image\/.*}

  do_not_validate_attachment_file_type :logo
  do_not_validate_attachment_file_type :white_logo
  do_not_validate_attachment_file_type :cover
  do_not_validate_attachment_file_type :icon

  scope :by_published, ->(published) { where(published: published) }
  scope :by_featured, ->(featured) { where(featured: featured) }
  scope :by_partner_type, ->(by_partner_type) { where(by_partner_type: by_partner_type) }
  scope :production, -> { where(production: true) }
  scope :pre_production, -> { where(pre_production: true) }
  scope :staging, -> { where(staging: true) }

  def self.fetch_all(options = {})
    partners = Partner.all
    if options[:filter]
      partners = partners.by_published(options[:filter][:published]) if options[:filter][:published]
      partners = partners.by_featured(options[:filter][:featured]) if options[:filter][:featured]
      partners = partners.by_partner_type(options[:filter][:by_partner_type]) if options[:filter][:by_partner_type]
    end

    if options[:env]
      environments = options[:env].split(',')

      ids = environments.map do |env|
        Partner.where(env => true)
      end.flatten.uniq.pluck(:id)

      partners = partners.where(id: ids)
    else
      partners = partners.production
    end
    
    partners = partners.order(get_order(options))
  end

  def self.get_order(options = {})
    field = 'created_at'
    direction = 'ASC'
    if options['sort']
      f = options['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      if Partner.new.has_attribute?(field)
        direction = f[0] == '-' ? 'DESC' : 'ASC'
      else
        field = 'created_at'
      end
    end
    "#{field} #{direction}"
  end

  private

  def parse_image(property, parameter)
    return if parameter.nil?
    image = Paperclip.io_adapters.for(parameter)
    image.original_filename = 'file.jpg'
    send "#{property}=", image
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
