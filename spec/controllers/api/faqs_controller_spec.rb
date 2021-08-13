# frozen_string_literal: true

require 'spec_helper'

describe Api::FaqsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_faq = FactoryBot.create(:faq_production)
      @staging_faq = FactoryBot.create(:faq, environment: 'staging')
      @preproduction_faq = FactoryBot.create(:faq, environment: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      get :index, params: {}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@production_faq.id])
    end

    it 'filters by single env' do
      get :index, params: {environment: 'staging'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id])
    end

    it 'filters by multiple envs' do
      get :index, params: {environment: [Environment::PRODUCTION, 'preproduction'].join(',')}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@production_faq.id, @preproduction_faq.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {environment: 'STAGing ,,,'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id])
    end

    it "returns no results if specified env doesn't match anything" do
      get :index, params: {environment: 'pre-production'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([])
    end
  end
end
