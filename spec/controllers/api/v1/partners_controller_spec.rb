# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::PartnersController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @partner = FactoryGirl.create :partner
      get :show, params: { id: @partner.id }
    end

    it 'returns the information about a partner on a hash' do
      partner_response = json_response
      expect(partner_response.dig(:data, :attributes, :name)).to eql @partner.name
    end

    it { should respond_with 200 }
  end
end