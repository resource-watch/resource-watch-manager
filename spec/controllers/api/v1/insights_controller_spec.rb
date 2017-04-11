# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::InsightsController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @insight = FactoryGirl.create :insight
      get :show, params: { id: @insight.id }
    end

    it 'returns the information about a insight on a hash' do
      insight_response = json_response
      expect(insight_response.dig(:data, :attributes, :title)).to eql @insight.title
    end

    it { should respond_with 200 }
  end
end
