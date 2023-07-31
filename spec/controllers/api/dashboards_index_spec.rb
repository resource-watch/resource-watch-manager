# frozen_string_literal: true

require 'constants'
require 'spec_helper'

describe Api::DashboardsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_dashboard = FactoryBot.create(:dashboard_production)
      @staging_dashboard = FactoryBot.create(:dashboard, env: 'staging')
      @preproduction_dashboard = FactoryBot.create(:dashboard, env: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: {}
          dashboard_ids = assigns(:dashboards).map(&:id)
          expect(dashboard_ids).to eq([@production_dashboard.id])
        end
      end
    end

    it 'filters by single env' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { env: 'staging' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'staging' }
          dashboard_ids = assigns(:dashboards).map(&:id)
          expect(dashboard_ids).to eq([@staging_dashboard.id])
        end
      end
    end

    it 'filters by multiple envs' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { env: [Environment::PRODUCTION, 'preproduction'].join(',') }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: [Environment::PRODUCTION, 'preproduction'].join(',') }
          dashboard_ids = assigns(:dashboards).map(&:id)
          expect(dashboard_ids).to eq([@production_dashboard.id, @preproduction_dashboard.id])
        end
      end
    end

    it 'filters by env with weird spellings' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { env: 'STAGing ,,,' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'STAGing ,,,' }
          dashboard_ids = assigns(:dashboards).map(&:id)
          expect(dashboard_ids).to eq([@staging_dashboard.id])
        end
      end
    end

    it "returns no results if specified env doesn't match anything" do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { env: 'pre-production' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'pre-production' }
          dashboard_ids = assigns(:dashboards).map(&:id)
          expect(dashboard_ids).to eq([])
        end
      end
    end
  end
end
