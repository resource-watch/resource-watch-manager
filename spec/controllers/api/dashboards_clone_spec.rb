# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'POST #dashboard clone endpoint' do
    before(:each) do
      @dashboard = FactoryBot.create :dashboard_with_widgets
    end

    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {id: '1', loggedUser: USERS[:ADMIN]}
        expect(response.status).to eq(200)
      end
    end

    it 'clones the dashboard overriding data provided in the request body' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {
          id: @dashboard.id,
          loggedUser: USERS[:ADMIN],
          data: {
            "attributes": {
              "user-id": USERS[:ADMIN][:id]
            }
          },
        }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['attributes']['user-id']).to eq(USERS[:ADMIN][:id])
      end
    end
  end
end
