# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                 :integer          not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  content            :text
#  published          :boolean
#  summary            :string
#  private            :boolean          default(TRUE)
#  user_id            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Topic < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]
  validates_presence_of :name

  before_validation :parse_image
  attr_accessor :image_base

  has_many :content_images, as: :imageable, dependent: :destroy

  has_attached_file :photo, styles: { cover: '1280x>', thumb: '110x>', medium: '500x' }
  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

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

  def duplicate(token)
    widgets = clone_widgets(token)
    clone_topic(widgets)
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

  def clone_widgets(token)
    widget_list = obtain_widget_list(content)
    create_widgets(widget_list, token)
  end

  def obtain_widget_list(content)
    widgets_list = content.scan(/widgetId":"([^"]*)","datasetId":"([^"]*)"/)
    widgets_list.map { |w| {widget_id: w.first, dataset_id: w.last} }
  end

  def create_widgets(widgets_list, token)
    new_widgets_list = []
    a = 20
    widgets_list.each do |widget|
      # TODO test this with the API
      new_widget_id = (a+=1).to_s #WidgetService.clone(token, widget[:widget_id], widget[:dataset_id])
      new_widgets_list << { old_id: widget[:widget_id], new_id: new_widget_id }
    end
    new_widgets_list
  end

  def clone_topic(widgets = [])
    new_topic = self.dup
    new_content = self.content
    widgets.each { |x| new_content.gsub!(x[:old_id], x[:new_id]) }
    new_topic.content = new_content
    new_topic.save
  end
end
