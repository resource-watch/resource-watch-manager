# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'POST #dashboard' do
    it 'with no user details should produce a 401 error' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
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

    it 'with role USER should create the dashboard (happy case)' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "production": true,
            "preproduction": false,
            "staging": false,
            "application": [
              "rw"
            ]
          }
        },
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "production": true,
            "preproduction": false,
            "staging": false,
          }
        },
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
    end

    it 'with role USER an non-matching applications should produce an 403 error' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
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

    it 'with role MANAGER should create the dashboard' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "production": true,
            "preproduction": false,
            "staging": false,
            "application": [
              "rw"
            ]
          }
        },
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(201)

      sampleDashboard = json_response[:data]

      validate_dashboard_structure(sampleDashboard)

      expect(sampleDashboard[:attributes][:application]).to eq(['rw'])
    end

    it 'without an application value should create the dashboard with the default application value' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "production": true,
            "preproduction": false,
            "staging": false,
            "application": %w(rw gfw prep)
          }
        },
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)

      sampleDashboard = json_response[:data]

      validate_dashboard_structure(sampleDashboard)

      expect(sampleDashboard[:attributes][:application]).to eq(%w(rw gfw prep))
    end

    it 'with multiple application values should create the dashboard with the multiple application values' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "production": true,
            "preproduction": false,
            "staging": false,
            "application": %w(rw gfw prep)

          }
        },
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)

      sampleDashboard = json_response[:data]

      validate_dashboard_structure(sampleDashboard)

      expect(sampleDashboard[:attributes][:application]).to eq(%w(rw gfw prep))
    end

    it 'with role ADMIN should create the dashboard providing the is-highlighted attribute' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "application": [
              "rw"
            ],
            "is-highlighted": true
          }
        },
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)
      sampleDashboard = json_response[:data]
      validate_dashboard_structure(sampleDashboard)
      expect(sampleDashboard[:attributes]['is-highlighted'.to_sym]).to eq(true)
    end

    it 'with role MANAGER should not create the dashboard providing the is-highlighted attribute' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "application": [
              "rw"
            ],
            "is-highlighted": true
          }
        },
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
    end

    it 'with role USER should not create the dashboard providing the is-highlighted attribute' do
      post :create, params: {
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
            "user-id": "57ac9f9e29309063404573a2",
            "private": true,
            "application": [
              "rw"
            ],
            "is-highlighted": true
          }
        },
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
    end
  end
end
