# == Schema Information
#
# Table name: dashboards
#
#  id                 :integer          not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  content            :text
#  published          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  summary            :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :string
#  private            :boolean          default(TRUE)
#

class Dashboard < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i(slugged)
  validates_presence_of :name

  before_validation :parse_image
  attr_accessor :image_base

  has_attached_file :photo, styles: { cover: '1280x800>', thumb: '110x110>' }
  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

  scope :by_published, -> published { where(published: published) }
  scope :by_private, -> is_private { where(private: is_private) }
  scope :by_user, -> user { where(user_id: user) }

  def self.fetch_all(options={})
    dashboards = Dashboard.all
    if options[:filter]
      dashboards = dashboards.by_published(options[:filter][:published]) if options[:filter][:published]
      dashboards = dashboards.by_private(options[:filter][:private]) if options[:filter][:private]
      dashboards = dashboards.by_user(options[:filter][:user]) if options[:filter][:user]
    end
    dashboards = dashboards.order(self.get_order(options))
  end

  def self.fetch_related(dashboard, options={})
    conn = Faraday.new(url: ENV['RW_API_URL'])
    response = conn.get "/v1/graph/query/concepts-inferred?concepts=#{dashboard.tags}"
    json = JSON.parse(response.body)
    related_tags = json["data"].map { |tag| tag["id"] }

    dashboards = related_tags.map do |tag|
      Dashboard.where("tags like ?", "%#{tag}%")
    end.flatten.uniq

    rescue
      []
  end

  def tags_array
    tags.present? ? tags.split(',').map(&:strip) : []
  end

  def self.get_order(options={})
    field = 'created_at'
    direction = 'ASC'
    if options['sort']
      f = options['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      if Dashboard.new.has_attribute?(field)
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
end
