# frozen_string_literal: true

# API versioning
class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/json; version=#{@version}")
  end
end
