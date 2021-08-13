require 'active_support/concern'

module Environment
  extend ActiveSupport::Concern

  STAGING = 'staging'.freeze
  PRODUCTION = 'production'.freeze
  PREPRODUCTION = 'preproduction'.freeze

  included do
    # default to production if environment not specified
    before_validation(on: :create) { self.environment ||= PRODUCTION }
    validates :environment, presence: true
  end
end
