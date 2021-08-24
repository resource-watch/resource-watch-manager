# frozen_string_literal: true

require 'spec_helper'

describe Api::FaqsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_faq = FactoryBot.create(:faq_production)
      @staging_faq = FactoryBot.create(:faq, env: 'staging')
      @preproduction_faq = FactoryBot.create(:faq, env: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      get :index, params: {}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@production_faq.id])
    end

    it 'filters by single env' do
      get :index, params: {env: 'staging'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id])
    end

    it 'filters by multiple envs' do
      get :index, params: {env: [Environment::PRODUCTION, 'preproduction'].join(',')}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@production_faq.id, @preproduction_faq.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {env: 'STAGing ,,,'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id])
    end

    it "returns no results if specified env doesn't match anything" do
      get :index, params: {env: 'pre-production'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([])
    end
  end

  describe 'GET #show' do
    before(:each) do
      @faq = FactoryBot.create :faq_production
      get :show, params: {id: @faq.id}
    end

    it 'returns the information about a faq on a hash' do
      faq_response = json_response
      expect(faq_response.dig(:data, :attributes, :question)).to eql @faq.question
    end

    it 'returns env' do
      faq_response = json_response
      expect(faq_response.dig(:data, :attributes, :env)).to eql @faq.env
    end

    it { should respond_with 200 }
  end


  describe 'POST #create' do
    it 'with no user details should produce a 401 error' do
      post :create

      expect(response.status).to eq(401)
      expect(response.body).to include 'Unauthorized'
    end

    context 'env' do
      it 'sets env to default if not specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {question: 'foo', answer: 'bar'}}}
          faq = Faq.find_by_question('foo')
          expect(faq.env).to eq(Environment::PRODUCTION)
        end
      end

      it 'sets env if specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {question: 'foo', answer: 'bar', env: 'potato'}}}
          faq = Faq.find_by_question('foo')
          expect(faq.env).to eq('potato')
        end
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @staging_faq = FactoryBot.create(:faq, env: 'staging')
    end

    it 'with no user details should produce a 401 error' do
      patch :update, params: {id: @staging_faq.id}

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    context 'env' do
      it "doesn't update env if not specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          put :update, params: {id: @staging_faq.id, data: {attributes: {answer: 'zonk'}}}
          expect(@staging_faq.reload.env).to eq('staging')
        end
      end

      it "updates env if specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          put :update, params: {id: @staging_faq.id, data: {attributes: {env: Environment::PRODUCTION}}}
          expect(@staging_faq.reload.env).to eq(Environment::PRODUCTION)
        end
      end
    end
  end

  describe 'DELETE #faq' do
    before(:each) do
      @faq = FactoryBot.create :faq, env: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      delete :destroy, params: {id: @faq.id}

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end
  end
end
