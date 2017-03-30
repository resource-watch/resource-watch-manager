# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::StaticPagesController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @static_page = FactoryGirl.create :static_page
      get :show, params: { id: @static_page.id }
    end

    it 'returns the information about a static page on a hash' do
      static_page_response = json_response
      expect(static_page_response.dig(:data, :attributes, :title)).to eql @static_page.title
    end

    it { should respond_with 200 }
  end
end
