# frozen_string_literal: true

require 'spec_helper'

describe Api::PartnersController, type: :controller do
  describe 'GET #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner
      get :show, params: { id: @partner.id }
    end

    it 'returns the information about a partner on a hash' do
      partner_response = json_response
      expect(partner_response.dig(:data, :attributes, :name)).to eql @partner.name
    end

    it { should respond_with 200 }
  end

  describe 'GET #partner by slug' do
    before(:each) do
      @partner = FactoryBot.create :partner
      get :show, params: { id: @partner.slug }
    end

    it 'returns the information about a partner on a hash' do
      partner_response = json_response
      expect(partner_response.dig(:data, :attributes, :name)).to eql @partner.name
    end

    it { should respond_with 200 }
  end

  describe 'POST #partner' do
    it 'with no user details should produce a 401 error' do
      post :create

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end
  end

  describe 'PATCH #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner
    end

    it 'with no user details should produce a 401 error' do
      patch :update, params: {
        id: @partner[:id]
      }

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end
  end

  describe 'DELETE #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner
    end

    it 'with no user details should produce a 401 error' do
      delete :destroy, params: {
        id: @partner[:id]
      }

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end
  end
end
