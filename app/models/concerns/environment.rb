require 'active_support/concern'

module Environment
  extend ActiveSupport::Concern

  PRODUCTION = 'production'.freeze

  included do
    # default to production if environment not specified
    before_validation(on: :create) { self.env ||= PRODUCTION }
    validates :env, presence: true
  end
end
