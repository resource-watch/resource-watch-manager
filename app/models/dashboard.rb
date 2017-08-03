class Dashboard < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i(slugged)
  validates_presence_of :name

  # before_validation :parse_image
  # attr_accessor :image_base

  # validates_presence_of :title
  # has_attached_file :photo, styles: { cover: '1280x800>', thumb: '110x110>' }
  # validates_attachment_content_type :photo, content_type: %r{^image\/.*}
  # do_not_validate_attachment_file_type :photo

  scope :by_published, -> published { where(published: published) }

  def self.fetch_all(options={})
    dashboards = Dashboard.all
    if options[:filter]
      dashboards = dashboards.by_published(options[:filter][:published]) if options[:filter][:published]
    end
    dashboards = dashboards.order(self.get_order(options))
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

  # private

  # def parse_image(property, parameter)
  #   return if parameter.nil?
  #   image = Paperclip.io_adapters.for(parameter)
  #   image.original_filename = 'file.jpg'
  #   send "#{property}=", image
  # end
end
