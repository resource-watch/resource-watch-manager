# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'POST #topic clone endpoint' do
    before(:each) do
      FactoryBot.create :topic_with_widgets
    end

    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {id: '1', loggedUser: USERS[:ADMIN]}
        expect(response.status).to eq(200)
      end
    end
  end
end
