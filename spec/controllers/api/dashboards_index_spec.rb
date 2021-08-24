# frozen_string_literal: true

require 'spec_helper'

describe Api::DashboardsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_dashboard = FactoryBot.create(:dashboard_production)
      @staging_dashboard = FactoryBot.create(:dashboard, env: 'staging')
      @preproduction_dashboard = FactoryBot.create(:dashboard, env: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      get :index, params: {}
      dashboard_ids = assigns(:dashboards).map(&:id)
      expect(dashboard_ids).to eq([@production_dashboard.id])
    end

    it 'filters by single env' do
      get :index, params: {env: 'staging'}
      dashboard_ids = assigns(:dashboards).map(&:id)
      expect(dashboard_ids).to eq([@staging_dashboard.id])
    end

    it 'filters by multiple envs' do
      get :index, params: {env: [Environment::PRODUCTION, 'preproduction'].join(',')}
      dashboard_ids = assigns(:dashboards).map(&:id)
      expect(dashboard_ids).to eq([@production_dashboard.id, @preproduction_dashboard.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {env: 'STAGing ,,,'}
      dashboard_ids = assigns(:dashboards).map(&:id)
      expect(dashboard_ids).to eq([@staging_dashboard.id])
    end

    it "returns no results if specified env doesn't match anything" do
      get :index, params: {env: 'pre-production'}
      dashboard_ids = assigns(:dashboards).map(&:id)
      expect(dashboard_ids).to eq([])
    end
  end
end
