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
      "user-id": "57ac9f9e29309063404573a2",
      "private": true,
      "production": true,
      "preproduction": false,
      "staging": false
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

    it 'with role USER should create the dashboard (happy case)' do
      post :create, params: {
        data: get_new_dashboard_data,
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(201)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes][:application]).to eq(['rw'])
    end


    it 'with role USER that doesn\'t belong to rw and no explicit application should produce a 403 error' do
      spoofed_user = USERS[:USER].deep_dup
      spoofed_user[:extraUserData][:apps] = ["fake-app"]

      post :create, params: {
        data: get_new_dashboard_data,
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
    end

    it 'with role USER and non-matching applications should produce an 403 error' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            application: ["fake-app"] 
          }
        }),
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
    end

    it 'with role MANAGER should create the dashboard' do
      post :create, params: {
        "data": get_new_dashboard_data,
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(201)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes][:application]).to eq(['rw'])
    end

    it 'with multiple application values should create the dashboard with the multiple application values' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            application: %w(rw gfw prep)
          }
        }),
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes][:application]).to eq(%w(rw gfw prep))
    end

    it 'with role USER should not create the dashboard providing the is-highlighted attribute' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            "is-highlighted": true
          }
        }),
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
    end

    it 'with role MANAGER should not create the dashboard providing the is-highlighted attribute' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            "is-highlighted": true
          }
        }),
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
    end

    it 'with role ADMIN should create the dashboard providing the is-highlighted attribute' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            "is-highlighted": true
          }
        }),
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes]['is-highlighted'.to_sym]).to eq(true)
    end

    it 'with role USER should not create the dashboard providing the is-featured attribute' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            "is-featured": true
          }
        }),
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
    end

    it 'with role MANAGER should not create the dashboard providing the is-featured attribute' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            "is-featured": true
          }
        }),
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
    end

    it 'with role ADMIN should create the dashboard providing the is-featured attribute' do
      post :create, params: {
        data: get_new_dashboard_data({ 
          attributes: {
            "is-featured": true
          }
        }),
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes]['is-featured'.to_sym]).to eq(true)
    end
  end
end
