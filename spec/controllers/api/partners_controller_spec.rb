# frozen_string_literal: true

require 'spec_helper'

describe Api::PartnersController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_partner = FactoryBot.create(:partner_production)
      @staging_partner = FactoryBot.create(:partner, environment: 'staging')
      @preproduction_partner = FactoryBot.create(:partner, environment: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      get :index, params: {}
      partner_ids = assigns(:partners).map(&:id)
      expect(partner_ids).to eq([@production_partner.id])
    end

    it 'filters by single env' do
      get :index, params: {env: 'staging'}
      partner_ids = assigns(:partners).map(&:id)
      expect(partner_ids).to eq([@staging_partner.id])
    end

    it 'filters by multiple envs' do
      get :index, params: {env: [Environment::PRODUCTION, 'preproduction'].join(',')}
      partner_ids = assigns(:partners).map(&:id)
      expect(partner_ids).to eq([@production_partner.id, @preproduction_partner.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {env: 'STAGing ,,,'}
      partner_ids = assigns(:partners).map(&:id)
      expect(partner_ids).to eq([@staging_partner.id])
    end

    it "returns no results if specified env doesn't match anything" do
      get :index, params: {env: 'pre-production'}
      partner_ids = assigns(:partners).map(&:id)
      expect(partner_ids).to eq([])
    end
  end

  describe 'GET #partner' do
    before(:each) { @partner = FactoryBot.create :partner_production }
    context 'by id' do
      before(:each) do
        get :show, params: {id: @partner.id}
      end

      it 'returns the information about a partner on a hash' do
        partner_response = json_response
        expect(partner_response.dig(:data, :attributes, :name)).to eql @partner.name
      end

      it 'returns environment' do
        partner_response = json_response
        expect(partner_response.dig(:data, :attributes, :environment)).to eql @partner.environment
      end

      it { should respond_with 200 }
    end

    context 'by slug' do
      before(:each) do
        get :show, params: {id: @partner.slug}
      end

      it 'returns the information about a partner on a hash' do
        partner_response = json_response
        expect(partner_response.dig(:data, :attributes, :name)).to eql @partner.name
      end

      it { should respond_with 200 }
    end
  end

  describe 'POST #partner' do
    it 'with no user details should produce a 401 error' do
      post :create

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    context 'environment' do
      it 'sets environment to default if not specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {name: 'foo'}}}
          partner = Partner.find_by_name('foo')
          expect(partner.environment).to eq(Environment::PRODUCTION)
        end
      end

      it 'sets environment if specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {name: 'foo', environment: 'potato'}}}
          partner = Partner.find_by_name('foo')
          expect(partner.environment).to eq('potato')
        end
      end
    end
  end

  describe 'PATCH #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner, environment: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      patch :update, params: {id: @partner.id}

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    context 'environment' do
      it "doesn't update environment if not specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          patch :update, params: {
            id: @partner.id, data: {attributes: {answer: 'zonk'}}
          }
          expect(@partner.reload.environment).to eq('staging')
        end
      end

      it "updates environment if specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          patch :update, params: {
            id: @partner.id, data: {attributes: {environment: Environment::PRODUCTION}}
          }
          expect(@partner.reload.environment).to eq(Environment::PRODUCTION)
        end
      end
    end
  end

  describe 'DELETE #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner, environment: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      delete :destroy, params: {id: @partner.id}

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end
  end
end
