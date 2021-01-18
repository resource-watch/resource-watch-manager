# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'DELETE #topics' do
    before(:each) do
      @topic_private_manager = FactoryBot.create :topic_private_manager
    end

    it 'with no user details should produce a 401 error' do
      delete :destroy, params: {
        id: @topic_private_manager[:id]
      }

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    it 'with ADMIN token should delete the topic and return 204 No Content' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: {
          id: @topic_private_manager[:id],
        }

        expect(response.status).to eq(204)
      end
    end
  end
end
