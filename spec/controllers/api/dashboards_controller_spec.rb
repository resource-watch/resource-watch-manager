# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

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
      get :index, params: {private: false}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(3)
      expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with user=<userId> filter should return only dashboards associated with that user' do
      get :index, params: {user: '57a1ff091ebc1ad91d089bdc'}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with user=<userId> and private=true filters should return only private dashboards associated with that user' do
      get :index, params: {user: '57a1ff091ebc1ad91d089bdc', private: true}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([true])
    end

    it 'with user=<userId> and private=false filters should return only non-private dashboards associated with that user' do
      get :index, params: {user: '57a1ff091ebc1ad91d089bdc', private: false}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([false])
    end

    it 'with published=true and private=false filters should return only non-private, published dashboards' do
      get :index, params: {published: 'true', private: false}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(3)
      expect(data.map { |dashboard| dashboard[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with includes=user while not being logged in should return dashboards including user name and email address' do
      VCR.use_cassette("include_user") do
        get :index, params: {includes: 'user'}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
        data.each do |dashboard|
          expect(dashboard[:attributes][:user].keys).to eq([:name, :email])
        end
      end
    end

    it 'with includes=user while being logged in as USER should return dashboards including user name and email address' do
      VCR.use_cassette("include_user") do
        get :index, params: {includes: 'user', loggedUser: USERS[:USER].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
        data.each do |dashboard|
          expect(dashboard[:attributes][:user].keys).to eq([:name, :email])
        end
      end
    end

    it 'with includes=user while being logged in as MANAGER should return dashboards including user name and email address' do
      VCR.use_cassette("include_user") do
        get :index, params: {includes: 'user', loggedUser: USERS[:MANAGER].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
        data.each do |dashboard|
          expect(dashboard[:attributes][:user].keys).to eq([:name, :email])
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return dashboards including user name, email address and role' do
      VCR.use_cassette("include_user") do
        get :index, params: {includes: 'user', loggedUser: USERS[:ADMIN].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
        data.each do |dashboard|
          expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :role])
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return dashboards including user name, email address and role, even if only partial data is available' do
      VCR.use_cassette("include_user_partial") do
        get :index, params: {includes: 'user', loggedUser: USERS[:ADMIN].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)

        responseDatasetOne = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '57a1ff091ebc1ad91d089bdc' }
        responseDatasetTwo = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c143429f8d19932db9d06ea' }
        responseDatasetThree = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c069855ccc46a6660a4be68' }

        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])

        expect(responseDatasetOne[:attributes][:user][:name]).to eq('John Doe')
        expect(responseDatasetOne[:attributes][:user][:role]).to eq('ADMIN')
        expect(responseDatasetOne[:attributes][:user][:email]).to eq('john.doe@vizzuality.com')

        expect(responseDatasetTwo[:attributes][:user][:name]).to eq(nil)
        expect(responseDatasetTwo[:attributes][:user][:role]).to eq('USER')
        expect(responseDatasetTwo[:attributes][:user][:email]).to eq('jane.poe@vizzuality.com')

        expect(responseDatasetThree[:attributes][:user][:name]).to eq('mark')
        expect(responseDatasetThree[:attributes][:user][:role]).to eq('USER')
        expect(responseDatasetThree[:attributes][:user][:email]).to eq(nil)
      end
    end

    it 'with user.role=USER and not logged in should not filter by user role' do
      VCR.use_cassette("get_users_by_role_user") do
        get :index, params: {'user.role': 'USER', loggedUser: nil}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(%w(57a1ff091ebc1ad91d089bdc 5c143429f8d19932db9d06ea 5c069855ccc46a6660a4be68))
      end
    end

    it 'with user.role=USER while being logged in as USER should not filter by user role' do
      VCR.use_cassette("get_users_by_role_user") do
        get :index, params: {'user.role': 'USER', loggedUser: USERS[:USER].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(%w(57a1ff091ebc1ad91d089bdc 5c143429f8d19932db9d06ea 5c069855ccc46a6660a4be68))
      end
    end

    it 'with user.role=USER while being logged in as MANAGER should not filter by user role' do
      VCR.use_cassette("get_users_by_role_user") do
        get :index, params: {'user.role': 'USER', loggedUser: USERS[:MANAGER].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(5)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(%w(57a1ff091ebc1ad91d089bdc 5c143429f8d19932db9d06ea 5c069855ccc46a6660a4be68))
      end
    end

    it 'with user.role=USER while being logged in as ADMIN should filter by user role' do
      VCR.use_cassette("get_users_by_role_user") do
        get :index, params: {'user.role': 'USER', loggedUser: USERS[:ADMIN].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(2)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
      end
    end

    it 'with user.role=ADMIN while being logged in as ADMIN should filter by user role' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN', loggedUser: USERS[:ADMIN].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(3)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to include("5c143429f8d19932db9d06ea", "5c069855ccc46a6660a4be68")
      end
    end

    it 'with user.role=ADMIN and filter by user id while not being logged in should return dashboards that match both criteria' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN', user: '5c069855ccc46a6660a4be68'}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(1)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
      end
    end

    it 'with user.role=ADMIN and filter by user id while being logged in as ADMIN should return dashboards that match both criteria' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN', user: '5c069855ccc46a6660a4be68', loggedUser: USERS[:ADMIN].to_json}

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

  # Deprecated: this section tests filtering using the `filters[]` approach, which is deprecated. Use root level filters instead
  describe 'GET #index using deprecated `filters` param' do
    before(:each) do
      FactoryBot.create :dashboard_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_3
    end

    # deprecated: use private=false instead of filter[private]=false
    it 'with filter[private]=false filter should return only non-private dashboards' do
      get :index, params: {filter: {private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(3)
      expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with filter[user]=<userId> filter should return only dashboards associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc'}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with filter[user]=<userId> and filter[private]=true filters should return only private dashboards associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc', private: true}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([true])
    end

    it 'with filter[user]=<userId> and filter[private]=false filters should return only non-private dashboards associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc', private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([false])
    end

    it 'with filter[published]=true and filter[private]=false filters should return only non-private, published dashboards' do
      get :index, params: {filter: {published: 'true', private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(3)
      expect(data.map { |dashboard| dashboard[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with user.role=ADMIN and filter by user id while not being logged in should return dashboards that match both criteria' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN', filter: {user: '5c069855ccc46a6660a4be68'}}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(1)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
      end
    end

    it 'with user.role=ADMIN and filter by user id while being logged in as ADMIN should return dashboards that match both criteria' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: {'user.role': 'ADMIN', filter: {user: '5c069855ccc46a6660a4be68'}, loggedUser: USERS[:ADMIN].to_json}

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(1)
        expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
      end
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
