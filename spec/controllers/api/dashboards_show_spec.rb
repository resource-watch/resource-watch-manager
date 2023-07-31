# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @dashboard = FactoryBot.create :dashboard_private_user_1
    end

    it 'should return the information from this id' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards/#{@dashboard.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :show, params: { id: @dashboard.id }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data).to be_a(Hash)

          validate_dashboard_structure(json_response[:data])
        end
      end
    end

    it 'returns env' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards/#{@dashboard.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :show, params: { id: @dashboard.id }
          dashboard_response = json_response
          expect(dashboard_response.dig(:data, :attributes, :env)).to eql @dashboard.env
        end
      end
    end
  end
end
