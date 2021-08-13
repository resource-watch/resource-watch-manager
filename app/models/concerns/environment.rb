require 'active_support/concern'

module Environment
  extend ActiveSupport::Concern

  STAGING = 'staging'.freeze
  PRODUCTION = 'production'.freeze
  PREPRODUCTION = 'preproduction'.freeze
  OPTIONS = [STAGING, PRODUCTION, PREPRODUCTION].freeze

  included do
    # TODO: should this be just set to production if not provided?
    validates :environment, presence: true, inclusion: OPTIONS
  end
end
