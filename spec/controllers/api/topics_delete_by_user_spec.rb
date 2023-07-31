# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'Delete topic by user id' do
    before(:each) do
      @topic_private_manager = FactoryBot.create :topic_private_manager
      @topic_private_manager = FactoryBot.create :topic_private_user_1
      @topic_private_manager = FactoryBot.create :topic_not_private_user_1
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/by-user/#{@topic_private_manager[:id]}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy_by_user, params: {
            userId: @topic_private_manager[:id]
          }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'with role USER should produce an 403 error if the param id does not match' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/by-user/1234", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy_by_user, params: {
            userId: '1234',
          }

          expect(response.status).to eq(403)
          expect(response.body).to include "You need to be either ADMIN or owner of the topics you're trying to delete."
        end
      end
    end

    it 'with role MANAGER should produce an 403 error if the param id does not match' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/by-user/1234", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy_by_user, params: {
            userId: '1234',
          }

          expect(response.status).to eq(403)
          expect(response.body).to include "You need to be either ADMIN or owner of the topics you're trying to delete."
        end
      end
    end

    it 'with role USER should produce an 200 result and delete the user\'s topics' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/by-user/57a1ff091ebc1ad91d089bdc", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy_by_user, params: {
            userId: '57a1ff091ebc1ad91d089bdc',
          }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(2)
          expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(["57a1ff091ebc1ad91d089bdc"])

          database_topics = Topic.all
          expect(database_topics.size).to eq(1)
          expect(database_topics.map { |topic| topic[:user_id] }).not_to eq(["57a1ff091ebc1ad91d089bdc"])
        end
      end
    end

    it 'with role ADMIN should produce an 200 result and delete the user\'s topics' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/by-user/57a1ff091ebc1ad91d089bdc", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy_by_user, params: {
            userId: '57a1ff091ebc1ad91d089bdc',
          }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(2)
          expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(["57a1ff091ebc1ad91d089bdc"])

          database_topics = Topic.all
          expect(database_topics.size).to eq(1)
          expect(database_topics.map { |topic| topic[:user_id] }).not_to eq(["57a1ff091ebc1ad91d089bdc"])
        end
      end
    end

    it 'with microservice token should produce an 200 result and delete the user\'s topics' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/topics/by-user/57a1ff091ebc1ad91d089bdc", {}, USERS[:MICROSERVICE], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_microservice') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy_by_user, params: {
            userId: '57a1ff091ebc1ad91d089bdc',
          }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(2)
          expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(["57a1ff091ebc1ad91d089bdc"])

          database_topics = Topic.all
          expect(database_topics.size).to eq(1)
          expect(database_topics.map { |topic| topic[:user_id] }).not_to eq(["57a1ff091ebc1ad91d089bdc"])
        end
      end
    end
  end
end
