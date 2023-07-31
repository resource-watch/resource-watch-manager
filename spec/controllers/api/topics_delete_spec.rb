# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'DELETE #topics' do
    before(:each) do
      @topic_private_manager = FactoryBot.create :topic_private_manager
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/#{@topic_private_manager[:id]}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @topic_private_manager[:id]
          }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'with ADMIN token should delete the topic and return 204 No Content' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/#{@topic_private_manager[:id]}", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @topic_private_manager[:id],
          }

          expect(response.status).to eq(204)
        end
      end
    end

    it 'with microservice token token should delete the topic and return 204 No Content' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/#{@topic_private_manager[:id]}", {}, USERS[:MICROSERVICE], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_microservice') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @topic_private_manager[:id],
          }

          expect(response.status).to eq(204)
        end
      end
    end
  end
end
