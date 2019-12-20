# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'DELETE #dashboard' do
    before(:each) do
      @dashboard_private_manager = FactoryBot.create :dashboard_private_manager
      @dashboard_private_user_1 = FactoryBot.create :dashboard_private_user_1
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

    it 'with role MANAGER but not the owner of the dashboard should produce an 403 error' do
      delete :destroy, params: {
        id: @dashboard_private_user_1[:id],
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(403)
      expect(response.body).to include "You need to be either ADMIN or MANAGER and own the dashboard to update/delete it"
    end

    it 'with role MANAGER and the owner of the dashboard should return 204 No Content' do
      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(204)
    end

    it 'with ADMIN token should delete the dashboard and return 204 No Content' do
      delete :destroy, params: {
        id: @dashboard_private_manager[:id],
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(204)
    end
  end
end
