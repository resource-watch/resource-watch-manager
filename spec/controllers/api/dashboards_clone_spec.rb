# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

def compare_cloned_with_existing(cloned_dash, initial_id, user_id, override_data = {})
  initial_dashboard = Dashboard.find(initial_id)
  initial_dashboard_serialized = ActiveModelSerializers::SerializableResource.new(initial_dashboard).as_json[:data]
  initial_dashboard_serialized[:attributes] = initial_dashboard_serialized[:attributes].merge(override_data)

  # Id and slug must be different
  expect(cloned_dash['id']).to satisfy { |new_id| new_id != initial_dashboard_serialized[:id] }
  expect(cloned_dash['attributes']['slug']).to satisfy { |new_slug| new_slug != initial_dashboard_serialized[:slug] }

  # User id should match the id of the user who requested the clone
  expect(cloned_dash['attributes']['user-id']).to eq(user_id)

  # All other attributes should be the same, except for the ones which were overridden
  expect(cloned_dash['attributes']['name']).to eq(initial_dashboard_serialized[:attributes][:name])
  expect(cloned_dash['attributes']['summary']).to eq(initial_dashboard_serialized[:attributes][:summary])
  expect(cloned_dash['attributes']['description']).to eq(initial_dashboard_serialized[:attributes][:description])
  expect(cloned_dash['attributes']['published']).to eq(initial_dashboard_serialized[:attributes][:published])
  expect(cloned_dash['attributes']['private']).to eq(initial_dashboard_serialized[:attributes][:private])
  expect(cloned_dash['attributes']['env']).to eq(initial_dashboard_serialized[:attributes][:env])
  expect(cloned_dash['attributes']['application']).to eq(initial_dashboard_serialized[:attributes][:application])
  expect(cloned_dash['attributes']['is-highlighted']).to eq(false)
  expect(cloned_dash['attributes']['is-featured']).to eq(false)
  expect(cloned_dash['attributes']['photo']['cover']).to eq(initial_dashboard_serialized[:attributes][:photo][:cover])
  expect(cloned_dash['attributes']['photo']['thumb']).to eq(initial_dashboard_serialized[:attributes][:photo][:thumb])
  expect(cloned_dash['attributes']['photo']['original']).to eq(initial_dashboard_serialized[:attributes][:photo][:original])
  expect(cloned_dash['attributes']['author-title']).to eq(initial_dashboard_serialized[:attributes][:"author-title"])
  expect(cloned_dash['attributes']['author-image']['cover']).to eq(initial_dashboard_serialized[:attributes][:"author-image"][:cover])
  expect(cloned_dash['attributes']['author-image']['thumb']).to eq(initial_dashboard_serialized[:attributes][:"author-image"][:thumb])
  expect(cloned_dash['attributes']['author-image']['original']).to eq(initial_dashboard_serialized[:attributes][:"author-image"][:original])
end

describe Api::DashboardsController, type: :controller do
  describe 'POST #dashboard clone endpoint' do
    before(:each) do
      @dashboard = FactoryBot.create :dashboard_with_widgets
      @dashboard_no_content = FactoryBot.create :dashboard_without_widgets
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/dashboards/#{@dashboard.id}/clone", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          post 'clone', params: { id: @dashboard.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    it 'returns 200 OK with the created dashboard data when providing no data in request body (happy case)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/dashboards/#{@dashboard.id}/clone", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          VCR.use_cassette('dataset_widget_manager') do
            request.headers["x-api-key"] = "api-key-test"
            request.headers["Authorization"] = "abd"
            post 'clone', params: { id: @dashboard.id }
            request.headers["Authorization"] = nil

            expect(response.status).to eq(200)
            json_response = JSON.parse(response.body)
            compare_cloned_with_existing(json_response['data'], @dashboard['id'], USERS[:MANAGER][:id])
            request.headers["x-api-key"] = nil
          end
        end
      end
    end

    it 'returns 200 OK with the created dashboard data when providing valid data in request body (happy case)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/dashboards/#{@dashboard.id}/clone", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          VCR.use_cassette('dataset_widget_manager') do
            request.headers["x-api-key"] = "api-key-test"
            new_data = {
              name: 'Cloned dashboard',
              summary: 'Cloned summary',
              description: 'Cloned description',
              published: false,
              private: false,
              production: false,
              preproduction: false,
              staging: false,
              author_title: 'Example author title',
              'author-title': 'Example author title',
            }

            request.headers["Authorization"] = "abd"
            post 'clone', params: {
              id: @dashboard.id,
              data: { attributes: new_data },
            }
            request.headers["Authorization"] = nil

            expect(response.status).to eq(200)
            json_response = JSON.parse(response.body)
            compare_cloned_with_existing(json_response['data'], @dashboard['id'], USERS[:MANAGER][:id], new_data)
          end
        end
      end
    end

    it 'returns 200 OK with valid cloned dashboard (with original values kept) when providing invalid override data in request body' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/dashboards/#{@dashboard.id}/clone", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          VCR.use_cassette('dataset_widget_manager') do
            new_data = {
              id: '999',
              slug: 'slug',
              user_id: '1',
              is_highlighted: true,
              is_featured: true,
              application: ['fake-app'],
            }

            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post 'clone', params: {
              id: @dashboard.id,
              data: { attributes: new_data },
            }
            request.headers["Authorization"] = nil

            expect(response.status).to eq(200)
            json_response = JSON.parse(response.body)
            compare_cloned_with_existing(json_response['data'], @dashboard['id'], USERS[:MANAGER][:id])
          end
        end
      end
    end

    it 'cloning a dashboard with no content works, returning 200 OK with the newly cloned dashboard' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/dashboards/#{@dashboard_no_content.id}/clone", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          VCR.use_cassette('dataset_widget_manager') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post 'clone', params: { id: @dashboard_no_content.id }
            request.headers["Authorization"] = nil

            expect(response.status).to eq(200)
            json_response = JSON.parse(response.body)
            compare_cloned_with_existing(json_response['data'], @dashboard_no_content['id'], USERS[:MANAGER][:id])
          end
        end
      end
    end
  end
end
