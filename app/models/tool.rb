# frozen_string_literal: true
# == Schema Information
#
# Table name: tools
#
#  id                     :bigint(8)        not null, primary key
#  title                  :string
#  slug                   :string
#  summary                :string
#  description            :string
#  content                :text
#  url                    :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  published              :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  production             :boolean          default(TRUE)
#  preproduction          :boolean          default(FALSE)
#  staging                :boolean          default(FALSE)
#

class Tool < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  has_attached_file :thumbnail, styles: { medium: '350x>' }
  validates_attachment_content_type :thumbnail, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :thumbnail

  validates_presence_of :title

  scope :production, -> { where(production: true) }
  scope :pre_production, -> { where(pre_production: true) }
  scope :staging, -> { where(staging: true) }

  def should_generate_new_friendly_id?
    new_record?
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

  def self.fetch_all(options = {})
    tools = Tool.all
    if options[:filter]
      tools = tools.by_published(options[:filter][:published]) if options[:filter][:published]
    end

    if options[:env]
      environments = options[:env].split(',')

      ids = environments.map do |env|
        Tool.where(env => true)
      end.flatten.uniq.pluck(:id)

      tools = tools.where(id: ids)
    else
      tools = tools.production
    end

    tools = tools.order(get_order(options))
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end
