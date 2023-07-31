# frozen_string_literal: true
# == Schema Information
#
# Table name: dashboards
#
#  id                        :bigint           not null, primary key
#  application               :string           default(["\"rw\""]), not null, is an Array
#  author_image_content_type :string
#  author_image_file_name    :string
#  author_image_file_size    :bigint
#  author_image_updated_at   :datetime
#  author_title              :string           default("")
#  content                   :text
#  description               :string
#  env                       :text             default("production"), not null
#  is_featured               :boolean          default(FALSE)
#  is_highlighted            :boolean          default(FALSE)
#  name                      :string
#  photo_content_type        :string
#  photo_file_name           :string
#  photo_file_size           :bigint
#  photo_updated_at          :datetime
#  private                   :boolean          default(TRUE)
#  published                 :boolean
#  slug                      :string
#  summary                   :string
#  user_name                 :string
#  user_role                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :string
#

class Dashboard < ApplicationRecord
  include Duplicable
  include Environment
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]
  validates_presence_of :name

  before_validation :parse_image
  attr_accessor :image_base

  has_many :content_images, as: :imageable, dependent: :destroy

  has_attached_file :photo, styles: { cover: '1280x>', thumb: '110x>', medium: '500x' }
  validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :photo

  has_attached_file :author_image, styles: { cover: '1280x>', thumb: '110x>', medium: '500x' }
  validates_attachment_content_type :author_image, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :author_image

  scope :by_author_title, ->(author_title) { where("author_title ilike ?", "%#{author_title}%") }
  scope :by_application, ->(application) { where("?::varchar = ANY(application)", application) }
  scope :by_is_highlighted, ->(is_highlighted) { where(is_highlighted: is_highlighted) }
  scope :by_is_featured, ->(is_featured) { where(is_featured: is_featured) }
  scope :by_published, ->(published) { where(published: published) }
  scope :by_private, ->(is_private) { where(private: is_private) }
  scope :by_user, ->(user) { where(user_id: user) }
  scope :by_name, ->(name) { where("name ilike ?", "%#{name}%") }

  def self.fetch_all(options = {})
    dashboards = Dashboard.all

    # Deprecated: Please use the same filter options without nesting them in the `filter` param
    if options[:filter]
      dashboards = dashboards.by_published(options[:filter][:published]) if options[:filter][:published]
      dashboards = dashboards.by_private(options[:filter][:private]) if options[:filter][:private]
      dashboards = dashboards.by_user(options[:filter][:user]) if options[:filter][:user]
    end

    dashboards = dashboards.by_author_title(options['author-title'.to_sym]) if options['author-title'.to_sym]
    dashboards = dashboards.by_application(options[:application]) if options[:application]
    dashboards = dashboards.by_is_highlighted(options['is-highlighted'.to_sym]) if options['is-highlighted'.to_sym]
    dashboards = dashboards.by_is_featured(options['is-featured'.to_sym]) if options['is-featured'.to_sym]
    dashboards = dashboards.by_published(options[:published]) if options[:published]
    dashboards = dashboards.by_private(options[:private]) if options[:private]
    dashboards = dashboards.by_user(options[:user]) if options[:user]
    dashboards = dashboards.by_name(options[:name]) if options[:name]

    dashboards = dashboards.order(get_order(options))
  end

  def self.process_sort_string(sort)
    sort['user.name'] = 'user_name,id' if sort.include? 'user.name'
    sort['user.role'] = 'user_role,id' if sort.include? 'user.role'
    sort
  end

  def self.get_order(options = {})
    sort_string = ''
    if options['sort']
      process_sort_string(options['sort']).split(',').each do |sort|
        field_name = sort[0] == '-' ? sort[1..-1] : sort
        direction = sort[0] == '-' ? 'DESC' : 'ASC'
        field = Dashboard.new.has_attribute?(field_name) ? field_name : 'created_at'
        sort_string = sort_string + (sort_string.empty? ? '' : ', ') + "#{field} #{direction}"
      end
    end
    sort_string
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
            if content && content.is_a?(Hash) && content['type'] == 'image'
              contents = assign_content_image_url(contents, content, base_url, is_grid = true, grid = content_block)
            end
          end
        end
      end
    end

    update_column(:content, contents.to_json)
  end

  def duplicate(user_id = nil, override = {}, api_key)
    widgets = clone_widgets(user_id, api_key)
    override[:is_highlighted] = false
    override[:is_featured] = false
    clone_model(widgets, override)
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
                                            imageable_type: 'Dashboard', image: temp.image)

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
