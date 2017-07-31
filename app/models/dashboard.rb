class Dashboard < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i(slugged)
  validates_presence_of :name

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
end
