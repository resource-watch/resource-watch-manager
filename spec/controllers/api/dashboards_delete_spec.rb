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
      delete :destroy, params: {
        id: @dashboard_private_manager[:id]
      }

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    it 'with role USER should produce an 403 error' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @dashboard_private_manager[:id],
        }

        expect(response.status).to eq(403)
        expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
      end
    end

    it 'with role MANAGER, NOT the owner of the dashboard, should produce an 403 error' do
      VCR.use_cassette('user_manager_fake_id') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @dashboard_private_manager[:id],
        }

        expect(response.status).to eq(403)
        expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
      end
    end

    it 'with role MANAGER, owner of the dashboard, but non-matching applications between user and dashboard should produce an 403 error' do
      VCR.use_cassette('user_manager_fake_app') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @dashboard_private_manager[:id],
        }

        expect(response.status).to eq(403)
        expect(response.body).to include "Your user account does not have permissions to delete this dashboard"
      end
    end

    it 'with role MANAGER, owner of the dashboard, and at least one matching application between user and dashboard should return 204 No Content' do
      VCR.use_cassette('user_manager') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @dashboard_private_manager[:id],
        }

        expect(response.status).to eq(204)
      end
    end

    it 'with role ADMIN, NOT owner of the dashboard, but non-matching applications between user and dashboard should produce an 403 error' do
      VCR.use_cassette('user_admin_fake_id_app') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @dashboard_private_manager[:id],
        }

        expect(response.status).to eq(403)
        expect(response.body).to include "Your user account does not have permissions to delete this dashboard"
      end
    end

    it 'with role ADMIN, NOT owner of the dashboard, but at least one matching application between user and dashboard should return 204 No Content' do
      VCR.use_cassette('user_admin_fake_id_rw_gfw') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @dashboard_private_manager[:id],
        }

        expect(response.status).to eq(204)
      end
    end
  end
end
