# frozen_string_literal: true

module ApiHelper
  def connect_gateway
    Faraday.new(url: (ENV['APIGATEWAY_URL']).to_s) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger, Rails.logger    # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end
