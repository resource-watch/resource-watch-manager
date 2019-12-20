# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'PATCH #dashboard' do
    before(:each) do
      @dashboard_private_manager = FactoryBot.create :dashboard_private_manager
    end

    it 'with no user details should produce a 401 error' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": [
              "rw"
            ]
          }
        }
      }

      expect(response.status).to eq(401)
    end

    it 'with role USER should produce an 403 error' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": [
              "fake-app"
            ]
          }
        },
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
    end

    it 'with role MANAGER and non-matching applications between request and dashboard should produce an 403 error' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": [
              "fake-app"
            ]
          }
        },
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
    end

    it 'with role MANAGER and non-matching applications between user and dashboard should produce an 403 error' do
      spoofed_user = USERS[:MANAGER].deep_dup
      spoofed_user[:extraUserData][:apps] = ["fake-app"]

      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": [
              "rw"
            ]
          }
        },
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
    end

    it 'that doesn\'t belong to the user and with role MANAGER should produce an 403 error' do
      spoofed_user = USERS[:MANAGER].deep_dup
      spoofed_user[:id] = "cccd7c6e0a37126611fd7a5"

      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": %w(rw gfw)
          }
        },
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
    end

    it 'that belongs to the user and with role MANAGER and at least one matching applications between user and dashboard should update the dashboard' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": %w(rw gfw)
          }
        },
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(200)

      sampleDashboard = json_response[:data]

      validate_dashboard_structure(sampleDashboard)

      expect(sampleDashboard[:attributes][:application]).to eq(%w(rw gfw))
    end

    it 'with role ADMIN should update the dashboard with the multiple application values even if the user does not own the dashboard' do
      spoofed_user = USERS[:ADMIN].deep_dup
      spoofed_user[:id] = "cccd7c6e0a37126611fd7a5"

      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
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
            "application": %w(rw gfw prep)

          }
        },
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(200)

      sampleDashboard = json_response[:data]

      validate_dashboard_structure(sampleDashboard)

      expect(sampleDashboard[:attributes][:application]).to eq(%w(rw gfw prep))
    end

    it 'with role ADMIN should update the dashboard providing the is-highlighted attribute' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
          "type": "dashboards",
          "attributes": {
            "is-highlighted": true
          }
        },
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(200)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes]['is-highlighted'.to_sym]).to eq(true)
    end

    it 'with role MANAGER should not update the dashboard providing the is-highlighted attribute' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
          "type": "dashboards",
          "attributes": {
            "is-highlighted": true
          }
        },
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
    end

    it 'with role USER should not update the dashboard providing the is-highlighted attribute' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
          "type": "dashboards",
          "attributes": {
            "is-highlighted": true
          }
        },
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be either ADMIN or MANAGER and own the dashboard to update/delete it")
    end

    it 'with role ADMIN should update the dashboard providing the is-featured attribute' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
          "type": "dashboards",
          "attributes": {
            "is-featured": true
          }
        },
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(200)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes]['is-featured'.to_sym]).to eq(true)
    end

    it 'with role MANAGER should not update the dashboard providing the is-featured attribute' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
          "type": "dashboards",
          "attributes": {
            "is-featured": true
          }
        },
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:status)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:status]).to eq("403")
      expect(json_response[:errors][0][:title]).to eq("You need to be an ADMIN to create/update the provided attribute of the dashboard")
    end

    it 'with role USER should not update the dashboard providing the is-featured attribute' do
      patch :update, params: {
        id: @dashboard_private_manager[:id],
        "data": {
          "type": "dashboards",
          "attributes": {
            "is-featured": true
          }
        },
        loggedUser: USERS[:USER]
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
