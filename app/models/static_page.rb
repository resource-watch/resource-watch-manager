# frozen_string_literal: true
# == Schema Information
#
# Table name: static_pages
#
#  id                 :bigint(8)        not null, primary key
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
#  production         :boolean          default(TRUE)
#  preproduction      :boolean          default(FALSE)
#  staging            :boolean          default(FALSE)
#

# frozen_string_literal: true

# Static Page Model
class StaticPage < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  before_validation :parse_image
  attr_accessor :image_base

  has_attached_file :photo, styles: { medium: '350x>', cover: '1280x>' }
  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

  validates_presence_of :title

  scope :production, -> { where(production: true) }
  scope :pre_production, -> { where(pre_production: true) }
  scope :staging, -> { where(staging: true) }

  def should_generate_new_friendly_id?
    new_record?
  end

  def self.fetch_all(options = {})
    static_pages = StaticPage.all
    if options[:filter]
      static_pages = static_pages.by_published(options[:filter][:published]) if options[:filter][:published]
    end

    if options[:env]
      environments = options[:env].split(',')

      ids = environments.map do |env|
        StaticPage.where(env => true)
      end.flatten.uniq.pluck(:id)

      static_pages = static_pages.where(id: ids)
    else
      static_pages = static_pages.production
    end
    
    static_pages = static_pages.order(get_order(options))
  end

  def self.get_order(options = {})
    field = 'created_at'
    direction = 'ASC'
    if options['sort']
      f = options['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      if StaticPage.new.has_attribute?(field)
        direction = f[0] == '-' ? 'DESC' : 'ASC'
      else
        field = 'created_at'
      end
    end
    "#{field} #{direction}"
  end

  private

  def parse_image
    return if image_base.nil?
    image = Paperclip.io_adapters.for(image_base)
    image.original_filename = 'file.jpg'
    self.photo = image
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end
