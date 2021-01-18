# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'GET #index sorted by user fields' do
    before(:each) do
      @dashboard1 = FactoryBot.create :dashboard_not_private_user_3
      @dashboard2 = FactoryBot.create :dashboard_not_private_user_2
      @dashboard3 = FactoryBot.create :dashboard_not_private_user_1
    end

    it 'returns 403 Forbidden when trying to get dashboards sorted by user fields without authentication' do
      get :index, params: { sort: "user.name" }
      expect(response.status).to eq(403)
      expect(json_response).to have_key(:errors)
      expect(json_response[:errors][0]).to have_key(:title)
      expect(json_response[:errors][0][:title]).to eq("Sorting by user name or role not authorized.")
    end

    it 'returns 403 Forbidden when trying to get dashboards sorted by user fields as user with role USER' do
      VCR.use_cassette('user_user') do
        request.headers["Authorization"] = "abd"
        get :index, params: {
          includes: 'user',
          sort: "user.name",
        }
        expect(response.status).to eq(403)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][0]).to have_key(:title)
        expect(json_response[:errors][0][:title]).to eq("Sorting by user name or role not authorized.")
      end
    end

    it 'returns 403 Forbidden when trying to get dashboards sorted by user fields as user with role MANAGER' do
      VCR.use_cassette('user_manager') do
        request.headers["Authorization"] = "abd"
        get :index, params: {
          includes: 'user',
          sort: "user.name",
        }
        expect(response.status).to eq(403)
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][0]).to have_key(:title)
        expect(json_response[:errors][0][:title]).to eq("Sorting by user name or role not authorized.")
      end
    end

    it 'returns 200 OK when trying to get dashboards sorted by user name ASC as user with role ADMIN (happy case)' do
      VCR.use_cassette("include_user", :allow_playback_repeats => true) do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: {
            includes: 'user',
            sort: "user.name",
          }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard.dig(:attributes, :user, :name) }).to eq(['jane', 'mark', nil])
        end
      end
    end

    it 'returns 200 OK when trying to get dashboards sorted by user name DESC as user with role ADMIN (happy case)' do
      VCR.use_cassette("include_user", :allow_playback_repeats => true) do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: {
            includes: 'user',
            sort: "-user.name",
          }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard.dig(:attributes, :user, :name) }).to eq([nil, 'mark', 'jane'])
        end
      end
    end

    it 'returns 200 OK when trying to get dashboards sorted by user role ASC as user with role ADMIN (happy case)' do
      VCR.use_cassette("include_user", :allow_playback_repeats => true) do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: {
            includes: 'user',
            sort: "user.role",
          }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard.dig(:attributes, :user, :role) }).to eq(['ADMIN', 'USER', 'USER'])
        end
      end
    end

    it 'returns 200 OK when trying to get dashboards sorted by user role DESC as user with role ADMIN (happy case)' do
      VCR.use_cassette("include_user", :allow_playback_repeats => true) do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: {
            includes: 'user',
            sort: "-user.role",
          }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard.dig(:attributes, :user, :role) }).to eq(['USER', 'USER', 'ADMIN'])
        end
      end
    end

    it 'returns 200 OK with a correctly sorted list (case insensitive) when trying to get dashboards sorted by user name ASC as user with role ADMIN' do
      VCR.use_cassette("include_fake_users_1", :allow_playback_repeats => true) do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: {
            includes: 'user',
            sort: "user.name",
          }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard.dig(:attributes, :user, :name) }).to eq(['anthony', 'Bernard', 'carlos'])
        end
      end
    end

    it 'returns 200 OK with a deterministic list (sorted by id) when trying to get dashboards sorted by user name ASC as user with role ADMIN' do
      VCR.use_cassette("include_fake_users_2", :allow_playback_repeats => true) do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          dashboard_ids = [@dashboard1.id.to_s, @dashboard2.id.to_s, @dashboard3.id.to_s].sort
          get :index, params: {
            includes: 'user',
            sort: "user.name",
          }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard.dig(:attributes, :user, :name) }).to eq(['aaa', 'aaa', 'aaa'])
          expect(data.map { |dashboard| dashboard.dig(:id) }).to eq(dashboard_ids)
        end
      end
    end
  end
end
