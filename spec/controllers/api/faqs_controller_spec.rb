# frozen_string_literal: true

require 'spec_helper'

describe Api::FaqsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @staging_faq = FactoryBot.create(:faq_staging)
      @production_faq = FactoryBot.create(:faq_production)
      @preproduction_faq = FactoryBot.create(:faq_preproduction)
    end

    it 'returns unfiltered list' do
      get :index, params: {}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id, @production_faq.id, @preproduction_faq.id])
    end

    it 'filters by single env' do
      get :index, params: {environment: Environment::STAGING}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {environment: 'STAGing ,,,'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id])
    end

    it 'ignores bogus env filter' do
      get :index, params: {environment: 'ZONK,,,'}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@staging_faq.id, @production_faq.id, @preproduction_faq.id])
    end

    it 'returns list filtered by multiple envs' do
      get :index, params: {environment: [Environment::PRODUCTION, Environment::PREPRODUCTION].join(',')}
      faq_ids = assigns(:faqs).map(&:id)
      expect(faq_ids).to eq([@production_faq.id, @preproduction_faq.id])
    end
  end
end
