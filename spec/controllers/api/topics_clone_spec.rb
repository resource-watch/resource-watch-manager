# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe Api::TopicsController, type: :controller do
  describe 'POST #topic clone endpoint' do
    before(:each) do
      @topic = FactoryBot.create :topic_with_widgets
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics/#{@topic.id}/clone", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          post 'clone', params: { id: @topic.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics/#{@topic.id}/clone-dashboard", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          post 'clone_dashboard', params: { id: @topic.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'should perform the cloning' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics/#{@topic.id}/clone", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('dataset_widget_admin') do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post 'clone', params: { id: @topic.id }
            expect(response.status).to eq(200)
          end
        end
      end
    end

    it 'returns 404 Not Found when creating a dashboard clone from a topic that does not exist' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics/999/clone-dashboard", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('dataset_widget_admin') do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post 'clone_dashboard', params: { id: '999' }
            expect(response.status).to eq(404)
          end
        end
      end
    end

    it 'returns 200 OK with the created dashboard when creating a dashboard clone from a topic' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics/#{@topic.id}/clone-dashboard", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('dataset_widget_admin') do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post 'clone_dashboard', params: { id: @topic.id }
            expect(response.status).to eq(200)
            cloned_dashboard = json_response[:data]
            validate_dashboard_structure(cloned_dashboard)
            expect(cloned_dashboard[:attributes][:name]).to eq(@topic.name)
            expect(cloned_dashboard[:attributes][:description]).to eq(@topic.description)
            expect(cloned_dashboard[:attributes][:published]).to eq(@topic.published)
            expect(cloned_dashboard[:attributes][:application]).to eq(@topic.application)
            expect(cloned_dashboard[:attributes]["is-highlighted".to_sym]).to eq(false)
            expect(cloned_dashboard[:attributes]["is-featured".to_sym]).to eq(false)
            expect(cloned_dashboard[:attributes]["user-id".to_sym]).to eq(USERS[:ADMIN][:id])
          end
        end
      end
    end
  end
end
