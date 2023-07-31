# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'DELETE #dashboard' do
    before(:each) do
      @dashboard_private_manager = FactoryBot.create :dashboard_private_manager
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id]
          }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'with role USER should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id],
          }

          expect(response.status).to eq(403)
          expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
        end
      end
    end

    it 'with role MANAGER, NOT the owner of the dashboard, should produce an 403 error' do
      fake_manager = USERS[:MANAGER].clone
      fake_manager[:id] = "123"

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, fake_manager, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager_fake_id') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id],
          }

          expect(response.status).to eq(403)
          expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
        end
      end
    end

    it 'with role MANAGER, owner of the dashboard, but non-matching applications between user and dashboard should produce an 403 error' do
      fake_app_manager = USERS[:MANAGER].clone
      fake_app_manager[:extraUserData][:apps] = ['fake-app']

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, fake_app_manager, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager_fake_app') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id],
          }

          expect(response.status).to eq(403)
          expect(response.body).to include "Your user account does not have permissions to delete this dashboard"
        end
      end
    end

    it 'with role MANAGER, owner of the dashboard, and at least one matching application between user and dashboard should return 204 No Content' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id],
          }

          expect(response.status).to eq(204)
        end
      end
    end

    it 'with role ADMIN, NOT owner of the dashboard, but non-matching applications between user and dashboard should produce an 403 error' do
      fake_id_app_admin = USERS[:ADMIN].clone
      fake_id_app_admin[:extraUserData][:apps] = ['fake-app']
      fake_id_app_admin[:id] = '123'

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, fake_id_app_admin, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin_fake_id_app') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id],
          }

          expect(response.status).to eq(403)
          expect(response.body).to include "Your user account does not have permissions to delete this dashboard"
        end
      end
    end

    it 'with role ADMIN, NOT owner of the dashboard, but at least one matching application between user and dashboard should return 204 No Content' do
      fake_id_app_admin = USERS[:ADMIN].clone
      fake_id_app_admin[:extraUserData][:apps] = ['fake-app']
      fake_id_app_admin[:id] = '123'

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, fake_id_app_admin, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin_fake_id_rw_gfw') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: {
            id: @dashboard_private_manager[:id],
          }

          expect(response.status).to eq(204)
        end
      end
    end
  end
end
