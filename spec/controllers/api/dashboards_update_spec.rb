# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

def get_edit_dashboard_data(override = {})
  {
    "type": "dashboards",
    "attributes": {
      "name": "Cities",
      "summary": "test dashboard one summary",
      "description": "Dashboard that uses cities",
      "content": "test dashboard one description",
      "published": true,
      "photo": {
        "cover": "/photos/cover/missing.png",
        "thumb": "/photos/thumb/missing.png",
        "original": "/photos/original/missing.png"
      },
      "private": true,
      "production": true,
      "preproduction": false,
      "staging": false,
      "application": ["rw"],
      "author_title": "Author title",
      "author_image": {
        "cover": "/photos/cover/missing.png",
        "thumb": "/photos/thumb/missing.png",
        "original": "/photos/original/missing.png"
      },
    }
  }.deep_merge(override)
end

describe Api::DashboardsController, type: :controller do
  describe 'PATCH #dashboard' do
    before(:each) do
      @dashboard_private_manager = FactoryBot.create :dashboard_private_manager, env: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data,
          }

          expect(response.status).to eq(401)
        end
      end
    end

    it 'with role USER should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["x-api-key"] = "api-key-test"
          request.headers["Authorization"] = "abd"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data({
                                            attributes: {
                                              application: ["fake-app"]
                                            }
                                          }),
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'with role MANAGER and non-matching applications between request and dashboard should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["x-api-key"] = "api-key-test"
          request.headers["Authorization"] = "abd"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data({
                                            attributes: {
                                              application: ["fake-app"]
                                            }
                                          }),
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'with role MANAGER and non-matching applications between user and dashboard should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager_fake_app') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"

          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data,
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'that doesn\'t belong to the user and with role MANAGER should produce an 403 error' do
      fake_manager = USERS[:MANAGER].clone
      fake_manager[:id] = "123"

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, fake_manager, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager_fake_id') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data({
                                            attributes: {
                                              application: %w(rw gfw)
                                            }
                                          }),
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'that belongs to the user and with role MANAGER and at least one matching applications between user and dashboard should update the dashboard' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data({
                                            attributes: {
                                              application: %w(rw gfw)
                                            }
                                          }),
          }

          expect(response.status).to eq(200)
          sample_dashboard = json_response[:data]
          validate_dashboard_structure(sample_dashboard)
          expect(sample_dashboard[:attributes][:application]).to eq(%w(rw gfw))
        end
      end
    end

    it 'with role ADMIN should update the dashboard with the multiple application values even if the user does not own the dashboard' do
      fake_admin = USERS[:ADMIN].clone
      fake_admin[:id] = "123"

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, fake_admin, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin_fake_id') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: get_edit_dashboard_data({
                                            attributes: {
                                              application: %w(rw gfw prep)
                                            }
                                          }),
          }

          expect(response.status).to eq(200)
          sample_dashboard = json_response[:data]
          validate_dashboard_structure(sample_dashboard)
          expect(sample_dashboard[:attributes][:application]).to eq(%w(rw gfw prep))
        end
      end
    end

    it 'with role ADMIN should update the dashboard providing the is-highlighted attribute' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: {
              "type": "dashboards",
              "attributes": {
                "is-highlighted": true
              }
            },
          }

          expect(response.status).to eq(200)
          sample_dashboard = json_response[:data]
          validate_dashboard_structure(sample_dashboard)
          expect(sample_dashboard[:attributes]['is-highlighted'.to_sym]).to eq(true)
        end
      end
    end

    it 'with role MANAGER should not update the dashboard providing the is-highlighted attribute' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: {
              "type": "dashboards",
              "attributes": {
                "is-highlighted": true
              }
            },
          }

          expect(response.status).to eq(403)
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors][0]).to have_key(:status)
          expect(json_response[:errors][0]).to have_key(:title)
          expect(json_response[:errors][0][:status]).to eq("403")
          expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
        end
      end
    end

    it 'with role USER should not update the dashboard providing the is-highlighted attribute' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: {
              "type": "dashboards",
              "attributes": {
                "is-highlighted": true
              }
            },
          }

          expect(response.status).to eq(403)
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors][0]).to have_key(:status)
          expect(json_response[:errors][0]).to have_key(:title)
          expect(json_response[:errors][0][:status]).to eq("403")
          expect(json_response[:errors][0][:title]).to eq("You need to be either ADMIN or MANAGER and own the dashboard to update/delete it")
        end
      end
    end

    it 'with role ADMIN should update the dashboard providing the is-featured attribute' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: {
              "type": "dashboards",
              "attributes": {
                "is-featured": true
              }
            },
          }

          expect(response.status).to eq(200)
          sample_dashboard = json_response[:data]
          validate_dashboard_structure(sample_dashboard)
          expect(sample_dashboard[:attributes]['is-featured'.to_sym]).to eq(true)
        end
      end
    end

    it 'with role MANAGER should not update the dashboard providing the is-featured attribute' do

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: {
              "type": "dashboards",
              "attributes": {
                "is-featured": true
              }
            },
          }

          expect(response.status).to eq(403)
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors][0]).to have_key(:status)
          expect(json_response[:errors][0]).to have_key(:title)
          expect(json_response[:errors][0][:status]).to eq("403")
          expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
        end
      end
    end

    it 'with role USER should not update the dashboard providing the is-featured attribute' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @dashboard_private_manager[:id],
            data: {
              "type": "dashboards",
              "attributes": {
                "is-featured": true
              }
            },
          }

          expect(response.status).to eq(403)
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors][0]).to have_key(:status)
          expect(json_response[:errors][0]).to have_key(:title)
          expect(json_response[:errors][0][:status]).to eq("403")
          expect(json_response[:errors][0][:title]).to eq("You need to be either ADMIN or MANAGER and own the dashboard to update/delete it")
        end
      end
    end

    context 'env' do
      it "doesn't update env if not specified" do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PUT', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_manager') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            put :update, params: { id: @dashboard_private_manager.id, data: { attributes: { name: 'zonk' } } }
            expect(@dashboard_private_manager.reload.env).to eq('staging')
          end
        end
      end

      it "updates env if specified" do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PUT', "/api/dashboards/#{@dashboard_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_manager') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            put :update, params: { id: @dashboard_private_manager.id, data: { attributes: { env: Environment::PRODUCTION } } }
            expect(@dashboard_private_manager.reload.env).to eq(Environment::PRODUCTION)
          end
        end
      end
    end
  end
end
