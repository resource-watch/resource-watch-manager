# frozen_string_literal: true

require 'spec_helper'

describe Api::DashboardsController, type: :controller do
  describe 'POST #dashboard' do
    before(:each) do
      FactoryBot.create :dashboard_with_widgets
    end
    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {id: '1'}
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #index' do
    before(:each) do
      FactoryBot.create :dashboard_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_3
    end

    it 'should return all dashboards' do
      get :index

      expect(response.status).to eq(200)
      expect(json_response[:data].size).to eq(5)
    end

    it 'with private=false filter should return only non-private dashboards' do
      get :index, params: {filter: {private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(3)
      expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with user=<userId> filter should return only dashboards associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc'}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with user=<userId> and private=true filters should return only private dashboards associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc', private: true}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([true])
    end

    it 'with user=<userId> and private=false filters should return only non-private dashboards associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc', private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([false])
    end

    it 'with published=true and private=false filters should return only non-private, published dashboards' do
      get :index, params: {filter: {published: 'true', private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(3)
      expect(data.map { |dashboard| dashboard[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with includes=user should return dashboards including user details' do
      VCR.use_cassette("include_user") do
        get :index, params: {includes: 'user'}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
      end
    end

    it 'with user.role=USER should filter by user role' do
      VCR.use_cassette("get_users_by_role_user") do
        get :index, params: {'user.role': 'USER'}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(2)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
      end
    end

    it 'with user.role=ADMIN should filter by user role' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN'}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(3)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to include("5c143429f8d19932db9d06ea", "5c069855ccc46a6660a4be68")
      end
    end

    it 'with user.role=ADMIN and filter by user id should return dashboards that match both criteria' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN', filter: {user: '5c069855ccc46a6660a4be68'} }

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(1)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
      end
    end

    it 'should return a response in JSON API format' do
      get :index

      body = json_response
      record = body[:data].first

      expect(body).to include(:data)
      expect(record).to include(:id)
      expect(record).to include(:type)
      expect(record).to include(:attributes)

      expect(body[:data]).to be_a(Array)
      expect(record.keys.size).to eq(3)
    end
  end

  describe 'GET #show' do
    before(:each) do
      @dashboard = FactoryBot.create :dashboard_private_user_1
    end

    it 'should return the information from this id' do
      get :show, params: {id: @dashboard.id}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data).to be_a(Hash)
      expect(json_response[:data][:attributes][:name]).to eq(@dashboard.name)
    end

    it 'should return in json api format' do
    end
  end
end
