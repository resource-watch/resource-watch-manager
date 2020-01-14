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
      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
      expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
    end

    it 'with role MANAGER, NOT the owner of the dashboard, should produce an 403 error' do
      spoofed_user = USERS[:MANAGER].deep_dup
      spoofed_user[:id] = "123"

      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
      expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
    end

    it 'with role MANAGER, owner of the dashboard, but non-matching applications between user and dashboard should produce an 403 error' do
      spoofed_user = USERS[:MANAGER].deep_dup
      spoofed_user[:extraUserData][:apps] = ["fake-app"]

      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
      expect(response.body).to include "Your user account does not have permissions to delete this dashboard"
    end

    it 'with role MANAGER, owner of the dashboard, and at least one matching application between user and dashboard should return 204 No Content' do
      spoofed_user = USERS[:MANAGER].deep_dup
      spoofed_user[:extraUserData][:apps] = ["rw", "gfw"]

      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(204)
    end

    it 'with role ADMIN, NOT owner of the dashboard, but non-matching applications between user and dashboard should produce an 403 error' do
      spoofed_user = USERS[:ADMIN].deep_dup
      spoofed_user[:id] = "123"
      spoofed_user[:extraUserData][:apps] = ["fake-app"]

      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
      expect(response.body).to include "Your user account does not have permissions to delete this dashboard"
    end

    it 'with role ADMIN, NOT owner of the dashboard, but at least one matching application between user and dashboard should return 204 No Content' do
      spoofed_user = USERS[:ADMIN].deep_dup
      spoofed_user[:id] = "123"
      spoofed_user[:extraUserData][:apps] = ["rw", "gfw"]

      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(204)
    end
  end
end
