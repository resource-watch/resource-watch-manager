# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @dashboard = FactoryBot.create :dashboard_private_user_1
    end

    it 'should return the information from this id' do
      get :show, params: {id: @dashboard.id}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data).to be_a(Hash)

      sampleDashboard = json_response[:data]

      validate_dashboard_structure(sampleDashboard)
    end

    it 'returns env' do
      get :show, params: {id: @dashboard.id}
      dashboard_response = json_response
      expect(dashboard_response.dig(:data, :attributes, :env)).to eql @dashboard.env
    end
  end
end
