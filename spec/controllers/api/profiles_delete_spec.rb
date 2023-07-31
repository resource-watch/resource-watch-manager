# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::ProfilesController, type: :controller do
  describe 'DELETE #profile' do
    before(:each) do
      @profile_manager = FactoryBot.create :profile_manager
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/profiles/#{@profile_manager[:user_id]}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @profile_manager[:user_id]
          }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'with no profile for current user should produce an 404 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/profiles/#{USERS[:USER][:id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: USERS[:USER][:id],
          }

          expect(response.status).to eq(404)
          expect(response.body).to include "Wrong ID provided"
        end
      end
    end

    it 'with role USER should return 204 and delete the profile from the database' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/profiles/#{@profile_manager[:user_id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          expect(Profile.all.size).to eq(1)

          delete :destroy, params: {
            id: @profile_manager[:user_id],
          }

          expect(response.status).to eq(204)

          expect(Profile.all.size).to eq(0)
        end
      end
    end

    it 'with role MANAGER should return 204 and delete the profile from the database' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/profiles/#{@profile_manager[:user_id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @profile_manager[:user_id],
          }

          expect(response.status).to eq(204)

          database_profiles = Profile.all
          expect(database_profiles.size).to eq(0)
        end
      end
    end

    it 'with role ADMIN should return 204 and delete the profile from the database' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/profiles/#{@profile_manager[:user_id]}", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @profile_manager[:user_id],
          }

          expect(response.status).to eq(204)

          database_profiles = Profile.all
          expect(database_profiles.size).to eq(0)
        end
      end
    end

    it 'with microservice token should return 204 and delete the profile from the database' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/profiles/#{@profile_manager[:user_id]}", {}, USERS[:MICROSERVICE], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_microservice') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @profile_manager[:user_id],
          }

          expect(response.status).to eq(204)

          database_profiles = Profile.all
          expect(database_profiles.size).to eq(0)
        end
      end
    end
  end
end
