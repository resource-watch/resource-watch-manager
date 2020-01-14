# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @topic = FactoryBot.create :topic_private_user_1
    end

    it 'should return the information from this id' do
      get :show, params: {id: @topic.id}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data).to be_a(Hash)

      sampleTopic = json_response[:data]
      validate_topic_structure(sampleTopic)
    end
  end
end
