# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

def valid_link(url)
  if url
    expect(url).not_to include "loggedUser="
    expect(url).to include "v1/dashboard?"
  end
end

def expect_pagination_info(link, number, size)
  linkQueryParams = CGI.parse(URI.parse(link).query)
  expect(linkQueryParams['page[number]'][0]).to eq(number)
  expect(linkQueryParams['page[size]'][0]).to eq(size)
end

def validate_pagination_link_query_params(link, params)
  query_params = CGI.parse(URI.parse(link).query)
  params.each do |key, value|
    expect(query_params["#{key}"][0]).to eq(value)
  end
end

describe Api::DashboardsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @dashboard_private_user_1 = FactoryBot.create :dashboard_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_3
    end

    it 'should return all dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index

          expect(response.status).to eq(200)
          expect(json_response[:data].size).to eq(5)
          sampleDashboard = json_response[:data][0]
          validate_dashboard_structure(sampleDashboard)
        end
      end
    end

    it 'with private=false filter should return only non-private dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { private: "false" }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { private: false }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
        end
      end
    end

    it 'with name=<string> filter should return only dashboards with "string" in the name (full match)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { name: @dashboard_private_user_1.name }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { name: @dashboard_private_user_1.name }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)

          expect(data.map { |dashboard| dashboard[:attributes][:"name"] }.uniq).to eq([@dashboard_private_user_1.name])
        end
      end
    end

    it 'with name=<string> filter should return only dashboards with "string" in the name (partial match)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { name: @dashboard_private_user_1.name.split[1] }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { name: @dashboard_private_user_1.name.split()[1] }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to be >= 1
          expect(data.map { |dashboard| dashboard[:attributes][:"name"] }.uniq).to eq([@dashboard_private_user_1.name])
        end
      end
    end

    it 'with name=<string> filter should return dashboards with "string"/"String" in the name (case insensitivity)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { name: @dashboard_private_user_1.name.downcase }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { name: @dashboard_private_user_1.name.downcase }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to be >= 1
          expect(data.map { |dashboard| dashboard[:attributes][:"name"] }.uniq).to eq([@dashboard_private_user_1.name])
        end
      end
    end

    it 'with author-title=<string> filter should return only dashboards with "string" in the author title (full match)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { "author-title": @dashboard_private_user_1.author_title }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { "author-title": @dashboard_private_user_1.author_title }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes][:"author-title"] }.uniq).to eq([@dashboard_private_user_1.author_title])
        end
      end
    end

    it 'with author-title=<string> filter should return only dashboards with "string" in the author-title (partial match)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { "author-title": @dashboard_private_user_1.author_title.split[1] }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { "author-title": @dashboard_private_user_1.author_title.split()[1] }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to be >= 1
          expect(data.map { |dashboard| dashboard[:attributes][:"author-title"] }.uniq).to eq([@dashboard_private_user_1.author_title])
        end
      end
    end

    it 'with author-title=<string> filter should return dashboards with "string"/"String" in the author-title (case insensitivity)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { "author-title": @dashboard_private_user_1.author_title.downcase }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { "author-title": @dashboard_private_user_1.author_title.downcase }
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to be >= 1
          expect(data.map { |dashboard| dashboard[:attributes][:"author-title"] }.uniq).to eq([@dashboard_private_user_1.author_title])
        end
      end
    end

    it 'with author-title=<string> filter SQl injections are not allowed and the dashboards that match the filter should be returned anyway' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(5)
        end
      end
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { "author-title": "0%27%3B+drop+table+dashboards%3B+--" }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { "author-title": "0%27%3B+drop+table+dashboards%3B+--" }
          expect(response.status).to eq(200)
        end
      end
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          # dashboards table should not have been deleted, so 5 dashboards should be returned
          get :index
          data = json_response[:data]
          expect(response.status).to eq(200)
          expect(data.size).to eq(5)
        end
      end
    end

    it 'with user=<userId> filter should return only dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { user: '57a1ff091ebc1ad91d089bdc' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { user: '57a1ff091ebc1ad91d089bdc' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(2)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
        end
      end
    end

    it 'with user=<userId> and private=true filters should return only private dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { private: "true", user: '57a1ff091ebc1ad91d089bdc' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { user: '57a1ff091ebc1ad91d089bdc', private: true }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
          expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([true])
        end
      end
    end

    it 'with user=<userId> and private=false filters should return only non-private dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { private: "false", user: '57a1ff091ebc1ad91d089bdc' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { user: '57a1ff091ebc1ad91d089bdc', private: false }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
          expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([false])
        end
      end
    end

    it 'with user=<userId> and env=all filters should return all dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { env: 'all', user: '57a1ff091ebc1ad91d089bdc' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          FactoryBot.create :dashboard_private_user_1, env: :potato

          get :index, params: { user: '57a1ff091ebc1ad91d089bdc', env: 'all' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
        end
      end
    end

    it 'with published=true and private=false filters should return only non-private, published dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { private: 'false', published: 'true' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { published: 'true', private: false }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard[:attributes][:published] }.uniq).to eq([true])
          expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
        end
      end
    end

    it 'with is-highlighted=true filter should return only highlighted dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'is-highlighted': 'true' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { 'is-highlighted': true }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes]['is-highlighted'.to_sym] }.uniq).to eq([true])
        end
      end
    end

    it 'with is-highlighted=false filter should return only non-highlighted dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'is-highlighted': 'false' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { 'is-highlighted': false }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |dashboard| dashboard[:attributes]['is-highlighted'.to_sym] }.uniq).to eq([false])
        end
      end
    end

    it 'with is-featured=true filter should return only featured dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'is-featured': 'true' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { 'is-featured': true }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes]['is-featured'.to_sym] }.uniq).to eq([true])
        end
      end
    end

    it 'with is-featured=false filter should return only non-featured dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'is-featured': 'false' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { 'is-featured': false }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |dashboard| dashboard[:attributes]['is-featured'.to_sym] }.uniq).to eq([false])
        end
      end
    end

    it 'with includes=user while not being logged in should return dashboards including user name, email and photo' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'includes': 'user' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          VCR.use_cassette("include_user") do
            get :index, params: { includes: 'user' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
            data.each do |dashboard|
              expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo])
              expect(dashboard[:attributes][:user][:photo]).to be_url
            end
          end
        end
      end
    end

    it 'with includes=user while being logged in as USER should return dashboards including user name, email and photo' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'includes': 'user' }, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("include_user") do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { includes: 'user' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
            data.each do |dashboard|
              expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo])
              expect(dashboard[:attributes][:user][:photo]).to be_url
            end
          end
        end
      end
    end

    it 'with includes=user while being logged in as MANAGER should return dashboards including user name, email and photo' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'includes': 'user' }, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("include_user") do
          VCR.use_cassette('api_key_user_manager') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { includes: 'user' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
            data.each do |dashboard|
              expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo])
              expect(dashboard[:attributes][:user][:photo]).to be_url
            end
          end
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return dashboards including user name, email, photo and role' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'includes': 'user' }, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("include_user") do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { includes: 'user' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
            data.each do |dashboard|
              expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo, :role])
              expect(dashboard[:attributes][:user][:photo]).to be_url
            end
          end
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return dashboards including user name, email, photo and role, even if only partial data is available' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'includes': 'user' }, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("include_user_partial") do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { includes: 'user' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)

            response_dataset_one = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '57a1ff091ebc1ad91d089bdc' }
            response_dataset_two = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c143429f8d19932db9d06ea' }
            response_dataset_three = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c069855ccc46a6660a4be68' }

            expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])

            expect(response_dataset_one[:attributes][:user][:name]).to eq('John Doe')
            expect(response_dataset_one[:attributes][:user][:role]).to eq('ADMIN')
            expect(response_dataset_one[:attributes][:user][:email]).to eq('john.doe@vizzuality.com')
            expect(response_dataset_one[:attributes][:user][:photo]).to be_url

            expect(response_dataset_two[:attributes][:user][:name]).to eq(nil)
            expect(response_dataset_two[:attributes][:user][:role]).to eq('USER')
            expect(response_dataset_two[:attributes][:user][:email]).to eq('jane.poe@vizzuality.com')
            expect(response_dataset_two[:attributes][:user][:photo]).to be_url

            expect(response_dataset_three[:attributes][:user][:name]).to eq('mark')
            expect(response_dataset_three[:attributes][:user][:role]).to eq('USER')
            expect(response_dataset_three[:attributes][:user][:email]).to eq(nil)
            expect(response_dataset_three[:attributes][:user][:photo]).to be_url
          end
        end
      end
    end

    it 'with user.role=USER and not logged in should not filter by user role' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'USER' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          VCR.use_cassette("get_users_by_role_user") do
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'USER' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(%w(57a1ff091ebc1ad91d089bdc 5c143429f8d19932db9d06ea 5c069855ccc46a6660a4be68))
          end
        end
      end
    end

    it 'with user.role=USER while being logged in as USER should not filter by user role' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'USER' }, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("get_users_by_role_user") do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'USER' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(%w(57a1ff091ebc1ad91d089bdc 5c143429f8d19932db9d06ea 5c069855ccc46a6660a4be68))
          end
        end
      end
    end

    it 'with user.role=USER while being logged in as MANAGER should not filter by user role' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'USER' }, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("get_users_by_role_user") do
          VCR.use_cassette('api_key_user_manager') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'USER' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(%w(57a1ff091ebc1ad91d089bdc 5c143429f8d19932db9d06ea 5c069855ccc46a6660a4be68))
          end
        end
      end
    end

    it 'with user.role=USER while being logged in as ADMIN should filter by user role' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'USER' }, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("get_users_by_role_user") do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'USER' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(2)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
          end
        end
      end
    end

    it 'with user.role=ADMIN while being logged in as ADMIN should filter by user role' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'ADMIN' }, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("get_users_by_role_admin") do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'ADMIN' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(3)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to include("5c143429f8d19932db9d06ea", "5c069855ccc46a6660a4be68")
          end
        end
      end
    end

    it 'with user.role=ADMIN and filter by user id while not being logged in should return dashboards that match both criteria' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'ADMIN', user: '5c069855ccc46a6660a4be68' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          VCR.use_cassette("get_users_by_role_admin") do
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'ADMIN', user: '5c069855ccc46a6660a4be68' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(1)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
          end
        end
      end
    end

    it 'with user.role=ADMIN and filter by user id while being logged in as ADMIN should return dashboards that match both criteria' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { 'user.role': 'ADMIN', user: '5c069855ccc46a6660a4be68' }, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("get_users_by_role_admin") do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'ADMIN', user: '5c069855ccc46a6660a4be68' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(1)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
          end
        end
      end
    end

    it 'with filter by a single application value should return dashboards that belong to at least that application' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { application: 'rw' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          VCR.use_cassette("get_users_by_role_admin") do
            request.headers["x-api-key"] = "api-key-test"

            get :index, params: { application: 'rw' }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(3)
            expect(data.map { |dashboard| dashboard[:attributes][:application] }.uniq).to eq([['rw'], %w(rw gfw)])
          end
        end
      end
    end

    it 'with filter by an array with a single application value should return dashboards without being filtered (multiple filter values not supported)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { application: ['rw'] }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          VCR.use_cassette("get_users_by_role_admin") do
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { application: ['rw'] }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
          end
        end
      end
    end

    it 'with filter by multiple application should return dashboards without being filtered (multiple filter values not supported)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { application: %w[rw gfw] }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          VCR.use_cassette("get_users_by_role_admin") do
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { application: %w(rw gfw) }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(5)
          end
        end
      end
    end

    it 'should return a response in JSON API format' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
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
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { private: 'false' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { filter: { private: false } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
        end
      end
    end

    it 'with filter[user]=<userId> filter should return only dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { user: '57a1ff091ebc1ad91d089bdc' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { filter: { user: '57a1ff091ebc1ad91d089bdc' } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(2)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
        end
      end
    end

    it 'with filter[user]=<userId> and filter[private]=true filters should return only private dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { private: 'true', user: '57a1ff091ebc1ad91d089bdc' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { filter: { user: '57a1ff091ebc1ad91d089bdc', private: true } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
          expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([true])
        end
      end
    end

    it 'with filter[user]=<userId> and filter[private]=false filters should return only non-private dashboards associated with that user' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { private: 'false', user: '57a1ff091ebc1ad91d089bdc' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { filter: { user: '57a1ff091ebc1ad91d089bdc', private: false } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(1)
          expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
          expect(data.map { |dashboard| dashboard[:attributes][:private] }).to eq([false])
        end
      end
    end

    it 'with filter[published]=true and filter[private]=false filters should return only non-private, published dashboards' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { private: 'false', published: 'true' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { filter: { published: 'true', private: false } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(3)
          expect(data.map { |dashboard| dashboard[:attributes][:published] }.uniq).to eq([true])
          expect(data.map { |dashboard| dashboard[:attributes][:private] }.uniq).to eq([false])
        end
      end
    end

    it 'with user.role=ADMIN and filter by user id while not being logged in should return dashboards that match both criteria' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { user: '5c069855ccc46a6660a4be68' }, 'user.role': 'ADMIN' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          VCR.use_cassette("get_users_by_role_admin") do
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'ADMIN', filter: { user: '5c069855ccc46a6660a4be68' } }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(1)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
          end
        end
      end
    end

    it 'with user.role=ADMIN and filter by user id while being logged in as ADMIN should return dashboards that match both criteria' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { filter: { user: '5c069855ccc46a6660a4be68' }, 'user.role': 'ADMIN' }, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette("get_users_by_role_admin") do
          VCR.use_cassette('api_key_user_admin') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            get :index, params: { 'user.role': 'ADMIN', filter: { user: '5c069855ccc46a6660a4be68' } }

            data = json_response[:data]

            expect(response.status).to eq(200)
            expect(data.size).to eq(1)
            expect(data.map { |dashboard| dashboard[:attributes][:"user-id"] }.uniq).to eq(["5c069855ccc46a6660a4be68"])
          end
        end
      end
    end
  end

  describe 'GET #index with pagination' do
    before(:each) do
      FactoryBot.create :dashboard_private_user_1
      FactoryBot.create :dashboard_private_user_1
      FactoryBot.create :dashboard_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_not_private_user_1
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_2
      FactoryBot.create :dashboard_not_private_user_3
      FactoryBot.create :dashboard_not_private_user_3
      FactoryBot.create :dashboard_not_private_user_3
      FactoryBot.create :dashboard_not_private_user_3
    end

    it 'loads page 1 with 10 elements by default' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(10)
        end
      end
    end

    it 'accepts page[size] values' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { page: { size: '15' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { page: { size: 15 } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(15)
        end
      end
    end

    it 'accepts page[number] and page[size] values' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { page: { number: '2', size: '15' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { page: { size: 15, number: 2 } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
        end
      end
    end

    it 'accepts page[number] and page[size] values beyond available results, returning an empty result set' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { page: { number: '100', size: '15' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { page: { size: 15, number: 100 } }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(0)
        end
      end
    end

    it 'prevents very high page sizes' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { page: { size: '251' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { page: { size: 251 } }

          data = json_response

          expect(response.status).to eq(400)
          expect(data).to eq({ errors: [{ status: 400, title: "Invalid page size" }] })
        end
      end
    end

    it 'includes links objects with links for self, prev, next, first and last pages' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index

          body = json_response

          expect(body).to include(:data)
          expect(body[:data]).to be_a(Array)

          expect(body).to include(:links)
          expect(body[:links]).to be_a(Object)

          expect(body[:links][:self]).to be_a(String)
          expect_pagination_info(body[:links][:self], "1", "10")

          expect(body[:links][:first]).to be_a(String)
          expect_pagination_info(body[:links][:first], "1", "10")

          expect(body[:links][:last]).to be_a(String)
          expect_pagination_info(body[:links][:last], "2", "10")

          expect(body[:links][:prev]).to be_a(String)
          expect_pagination_info(body[:links][:prev], "1", "10")

          expect(body[:links][:next]).to be_a(String)
          expect_pagination_info(body[:links][:next], "2", "10")

          expect(body[:links][:first]).to eq(body[:links][:self])
          expect(body[:links][:prev]).to eq(body[:links][:self])
          expect(body[:links][:next]).to eq(body[:links][:last])
        end
      end
    end

    it 'includes meta objects with extra pagination info' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index

          body = json_response

          expect(body).to include(:meta)
          expect(body[:meta]).to be_a(Object)
          expect(body[:meta]['total-pages'.to_sym]).to be_a(Integer)
          expect(body[:meta]['total-items'.to_sym]).to be_a(Integer)
          expect(body[:meta][:size]).to be_a(Integer)
        end
      end
    end

    it 'includes correctly formatted pagination links' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          get :index
          body = json_response

          valid_link(body[:links][:self])
          valid_link(body[:links][:first])
          valid_link(body[:links][:last])
          valid_link(body[:links][:prev])
          valid_link(body[:links][:next])
        end
      end
    end

    it 'pagination meta information adjusts according to query pagination data' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { page: { number: '2', size: '5' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { page: { size: 5, number: 2 } }

          body = json_response

          expect(body).to include(:meta)
          expect(body[:meta]).to be_a(Object)
          expect(body[:meta]['total-pages'.to_sym]).to eq(4)
          expect(body[:meta]['total-items'.to_sym]).to eq(19)
          expect(body[:meta][:size]).to eq(5)
        end
      end
    end

    it 'pagination links adjusts according to query pagination data' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { page: { number: '3', size: '5' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { page: { size: 5, number: 3 } }
          body = json_response

          expect_pagination_info(body[:links][:self], "3", "5")
          expect_pagination_info(body[:links][:first], "1", "5")
          expect_pagination_info(body[:links][:last], "4", "5")
          expect_pagination_info(body[:links][:prev], "2", "5")
          expect_pagination_info(body[:links][:next], "4", "5")
        end
      end
    end

    it 'when requesting user data for dashboards, includes meta objects with extra pagination info' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { includes: 'user', page: { number: '3', size: '5' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { includes: 'user', page: { size: 5, number: 3 } }

          body = json_response

          expect(body).to include(:data)
          expect(body[:data]).to be_a(Array)

          expect(body).to include(:links)
          expect_pagination_info(body[:links][:self], "3", "5")
          expect_pagination_info(body[:links][:first], "1", "5")
          expect_pagination_info(body[:links][:last], "4", "5")
          expect_pagination_info(body[:links][:prev], "2", "5")
          expect_pagination_info(body[:links][:next], "4", "5")

          expect(body).to include(:meta)
          expect(body[:meta]).to be_a(Object)
          expect(body[:meta]['total-pages'.to_sym]).to be_a(Integer)
          expect(body[:meta]['total-items'.to_sym]).to be_a(Integer)
          expect(body[:meta][:size]).to be_a(Integer)
        end
      end
    end

    it 'when requesting user data for dashboards, get params are kept in the pagination links returned' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/dashboards", { includes: 'user', page: { number: '3', size: '5' } }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { includes: 'user', page: { size: 5, number: 3 } }
          body = json_response
          expect(body).to include(:links)

          validate_pagination_link_query_params(body[:links][:self], {
            'page[number]': '3',
            'page[size]': '5',
            'includes': 'user',
          })

          validate_pagination_link_query_params(body[:links][:first], {
            'page[number]': '1',
            'page[size]': '5',
            'includes': 'user',
          })

          validate_pagination_link_query_params(body[:links][:last], {
            'page[number]': '4',
            'page[size]': '5',
            'includes': 'user',
          })

          validate_pagination_link_query_params(body[:links][:prev], {
            'page[number]': '2',
            'page[size]': '5',
            'includes': 'user',
          })

          validate_pagination_link_query_params(body[:links][:next], {
            'page[number]': '4',
            'page[size]': '5',
            'includes': 'user',
          })
        end
      end
    end
  end
end
