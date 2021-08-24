# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

def get_new_dashboard_data(override = {})
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
  describe 'POST #dashboard' do
    it 'with no user details should produce a 401 error' do
      post :create, params: {
        data: get_new_dashboard_data
      }
      expect(response.status).to eq(401)
    end

    it 'with invalid token should return a meaningful message' do
      VCR.use_cassette('user_invalid_token') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data,
        }

        expect(response.status).to eq(401)
        expect(json_response[:errors][0][:status]).to eq(401)
        expect(json_response[:errors][0][:detail]).to eq('Your token is outdated. Please use /auth/login to login and /auth/generate-token to generate a new token.')
      end
    end

    it 'with role USER should create the dashboard (happy case)' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data,
        }

        expect(response.status).to eq(201)
        sampleDashboard = json_response[:data]
        validate_dashboard_structure(sampleDashboard)
        expect(sampleDashboard[:attributes][:application]).to eq(['rw'])
        expect(sampleDashboard[:attributes]["user-id".to_sym]).to eq(USERS[:USER][:id])
      end
    end

    it 'with role USER that doesn\'t belong to rw and no explicit application should produce a 403 error' do
      VCR.use_cassette('user_user_fake_app') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data,
        }

        expect(response.status).to eq(403)
      end
    end

    it 'with role USER and non-matching applications should produce an 403 error' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           application: ["fake-app"]
                                         }
                                       }),
        }

        expect(response.status).to eq(403)
      end
    end

    it 'with role MANAGER should create the dashboard' do
      VCR.use_cassette('user_manager') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          "data": get_new_dashboard_data,
        }

        expect(response.status).to eq(201)
        sampleDashboard = json_response[:data]
        validate_dashboard_structure(sampleDashboard)
        expect(sampleDashboard[:attributes][:application]).to eq(['rw'])
        expect(sampleDashboard[:attributes]["user-id".to_sym]).to eq(USERS[:MANAGER][:id])
      end
    end

    it 'with multiple application values should create the dashboard with the multiple application values' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           application: %w(rw gfw prep)
                                         }
                                       }),
        }

        expect(response.status).to eq(201)
        sampleDashboard = json_response[:data]
        validate_dashboard_structure(sampleDashboard)
        expect(sampleDashboard[:attributes][:application]).to eq(%w(rw gfw prep))
        expect(sampleDashboard[:attributes]["user-id".to_sym]).to eq(USERS[:ADMIN][:id])
      end
    end

    it 'returns 201 when providing a body containing a user_id and it matches the id of the user who created the dashboard' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: { user_id: "1" }
                                       }),
        }

        expect(response.status).to eq(201)
        sampleDashboard = json_response[:data]
        validate_dashboard_structure(sampleDashboard)
        expect(sampleDashboard[:attributes]["user-id".to_sym]).to eq(USERS[:USER][:id])
      end
    end

    it 'with role USER should not create the dashboard providing the is-highlighted attribute' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           "is-highlighted": true
                                         }
                                       }),
        }

        expect(response.status).to eq(403)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][0]).to have_key(:status)
        expect(json_response[:errors][0]).to have_key(:title)
        expect(json_response[:errors][0][:status]).to eq("403")
        expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
      end
    end

    it 'with role MANAGER should not create the dashboard providing the is-highlighted attribute' do
      VCR.use_cassette('user_manager') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           "is-highlighted": true
                                         }
                                       }),
        }

        expect(response.status).to eq(403)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][0]).to have_key(:status)
        expect(json_response[:errors][0]).to have_key(:title)
        expect(json_response[:errors][0][:status]).to eq("403")
        expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
      end
    end

    it 'with role ADMIN should create the dashboard providing the is-highlighted attribute' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           "is-highlighted": true
                                         }
                                       }),
        }

        expect(response.status).to eq(201)
        sampleDashboard = json_response[:data]
        validate_dashboard_structure(sampleDashboard)
        expect(sampleDashboard[:attributes]['is-highlighted'.to_sym]).to eq(true)
      end
    end

    it 'with role USER should not create the dashboard providing the is-featured attribute' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           "is-featured": true
                                         }
                                       }),
        }

        expect(response.status).to eq(403)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][0]).to have_key(:status)
        expect(json_response[:errors][0]).to have_key(:title)
        expect(json_response[:errors][0][:status]).to eq("403")
        expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
      end
    end

    it 'with role MANAGER should not create the dashboard providing the is-featured attribute' do
      VCR.use_cassette('user_manager') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           "is-featured": true
                                         }
                                       }),
        }

        expect(response.status).to eq(403)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][0]).to have_key(:status)
        expect(json_response[:errors][0]).to have_key(:title)
        expect(json_response[:errors][0][:status]).to eq("403")
        expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
      end
    end

    it 'with role ADMIN should create the dashboard providing the is-featured attribute' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        post :create, params: {
          data: get_new_dashboard_data({
                                         attributes: {
                                           "is-featured": true
                                         }
                                       }),
        }

        expect(response.status).to eq(201)
        sampleDashboard = json_response[:data]
        validate_dashboard_structure(sampleDashboard)
        expect(sampleDashboard[:attributes]['is-featured'.to_sym]).to eq(true)
      end
    end

    context 'env' do
      it 'sets env to default if not specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {name: 'foo'}}}
          dashboard = Dashboard.find_by_name('foo')
          expect(dashboard.env).to eq(Environment::PRODUCTION)
        end
      end

      it 'sets env if specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {name: 'foo', env: 'potato'}}}
          dashboard = Dashboard.find_by_name('foo')
          expect(dashboard.env).to eq('potato')
        end
      end
    end
  end
end
