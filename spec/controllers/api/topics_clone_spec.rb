# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'POST #topic clone endpoint' do
    before(:each) do
      @topic = FactoryBot.create :topic_with_widgets
    end

    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {id: @topic.id, loggedUser: USERS[:ADMIN]}
        expect(response.status).to eq(200)
      end
    end

    it 'returns 404 Not Found when creating a dashboard clone from a topic that does not exist' do
      VCR.use_cassette('dataset_widget') do
        post 'clone_dashboard', params: {id: '999', loggedUser: USERS[:ADMIN]}
        expect(response.status).to eq(404)
      end
    end

    it 'returns 200 OK with the created dashboard when creating a dashboard clone from a topic' do
      VCR.use_cassette('dataset_widget') do
        post 'clone_dashboard', params: {id: @topic.id, loggedUser: USERS[:ADMIN]}
        expect(response.status).to eq(200)
        clonedDashboard = json_response[:data]
        validate_dashboard_structure(clonedDashboard)
        expect(clonedDashboard[:attributes][:name]).to eq(@topic.name)
        expect(clonedDashboard[:attributes][:description]).to eq(@topic.description)
        expect(clonedDashboard[:attributes][:published]).to eq(@topic.published)
        expect(clonedDashboard[:attributes][:application]).to eq(@topic.application)
        expect(clonedDashboard[:attributes]["is-highlighted".to_sym]).to eq(false)
        expect(clonedDashboard[:attributes]["is-featured".to_sym]).to eq(false)
        expect(clonedDashboard[:attributes]["user-id".to_sym]).to eq(USERS[:ADMIN][:id])
      end
    end
  end
end
