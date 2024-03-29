# frozen_string_literal: true
# == Schema Information
#
# Table name: topics
#
#  id                 :bigint           not null, primary key
#  application        :string           default(["\"rw\""]), not null, is an Array
#  content            :text
#  description        :string
#  name               :string
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :bigint
#  photo_updated_at   :datetime
#  private            :boolean          default(TRUE)
#  published          :boolean
#  slug               :string
#  summary            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :string
#

class Topic < ApplicationRecord
  include Duplicable
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]
  validates_presence_of :name

  before_validation :parse_image
  attr_accessor :image_base

  has_many :content_images, as: :imageable, dependent: :destroy

  has_attached_file :photo, styles: { cover: '1280x>', thumb: '110x>', medium: '500x' }
  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

  scope :by_application, ->(application) { where("?::varchar = ANY(application)", application) }
  scope :by_published, ->(published) { where(published: published) }
  scope :by_private, ->(is_private) { where(private: is_private) }
  scope :by_user, ->(user) { where(user_id: user) }

  def self.fetch_all(options = {})
    topics = Topic.all
    if options[:filter]
      topics = topics.by_published(options[:filter][:published]) if options[:filter][:published]
      topics = topics.by_private(options[:filter][:private]) if options[:filter][:private]
      topics = topics.by_user(options[:filter][:user]) if options[:filter][:user]
    end

    topics = topics.by_application(options[:application]) if options[:application]
    topics = topics.by_published(options[:published]) if options[:published]
    topics = topics.by_private(options[:private]) if options[:private]
    topics = topics.by_user(options[:user]) if options[:user]

    topics.order(get_order(options))
  end

  def self.get_order(options = {})
    field = 'created_at'
    direction = 'ASC'
    if options['sort']
      f = options['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      if Topic.new.has_attribute?(field)
        direction = f[0] == '-' ? 'DESC' : 'ASC'
      else
        field = 'created_at'
      end
    end
    "#{field} #{direction}"
  end

  def manage_content(base_url)
    content_images.each(&:destroy)

    begin
      contents = JSON.parse(content)
    rescue JSON::ParserError, TypeError
      return
    end

    contents.each do |content_block|
      if content_block['type'] == 'image'
        contents = assign_content_image_url(contents, content_block, base_url)
      elsif content_block['type'] == 'grid'
        content_block['content'].compact.each do |column|
          column.each do |content|
            if content && content['type'] == 'image'
              contents = assign_content_image_url(contents, content, base_url, is_grid = true, grid = content_block)
            end
          end
        end
      end
    end

    update_column(:content, contents.to_json)
  end

  def duplicate(user_id = nil, api_key)
    widgets = clone_widgets(user_id, api_key)
    clone_model(widgets)
  end

  def duplicate_dashboard(user_id = nil, api_key)
    widgets = clone_widgets(user_id, api_key)
    clone_to Dashboard, widgets, user_id
  end

  private

  def parse_image
    return if image_base.nil?
    image = Paperclip.io_adapters.for(image_base)
    image.original_filename = 'file.jpg'
    self.photo = image
  end

  def create_content_image(content)
    uri = URI.parse(content['content']['src'])

    if uri.query.present?
      params = CGI.parse(uri.query)

      if params['temp_id'].present?
        temp = TemporaryContentImage.find(params['temp_id'].first)
        content_image = ContentImage.create(imageable_id: id,
                                            imageable_type: 'Topic', image: temp.image)

        temp.destroy
        content_image
      end
    end
  end

  def assign_content_image_url(contents, content, _base_url, is_grid = false, grid = nil)
    content_image = create_content_image(content)

    if content_image.present?
      if is_grid
        contents.find { |content_block| content_block['id'] == grid['id'] }['content'].flatten
                .find { |grid_item| grid_item['id'] == content['id'] }['content']['src'] = content_image.image.url(:cover)
      else
        contents.find { |item| item['id'] == content['id'] }['content']['src'] = content_image.image.url(:cover)
      end
    end

    contents
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
