# frozen_string_literal: true

require 'spec_helper'

describe Api::PartnersController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_partner = FactoryBot.create(:partner_production)
      @staging_partner = FactoryBot.create(:partner, env: 'staging')
      @preproduction_partner = FactoryBot.create(:partner, env: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: {}
          partner_ids = assigns(:partners).map(&:id)
          expect(partner_ids).to eq([@production_partner.id])
        end
      end
    end

    it 'filters by single env' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners", { env: 'staging' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'staging' }
          partner_ids = assigns(:partners).map(&:id)
          expect(partner_ids).to eq([@staging_partner.id])
        end
      end
    end

    it 'filters by multiple envs' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners", { env: [Environment::PRODUCTION, 'preproduction'].join(',') }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: [Environment::PRODUCTION, 'preproduction'].join(',') }
          partner_ids = assigns(:partners).map(&:id)
          expect(partner_ids).to eq([@production_partner.id, @preproduction_partner.id])
        end
      end
    end

    it 'filters by env with weird spellings' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners", { env: 'STAGing ,,,' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'STAGing ,,,' }
          partner_ids = assigns(:partners).map(&:id)
          expect(partner_ids).to eq([@staging_partner.id])
        end
      end
    end

    it "returns no results if specified env doesn't match anything" do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners", { env: 'pre-production' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'pre-production' }
          partner_ids = assigns(:partners).map(&:id)
          expect(partner_ids).to eq([])
        end
      end
    end
  end

  describe 'GET #partner' do
    before(:each) { @partner = FactoryBot.create :partner_production }
    context 'by id' do
      before(:each) do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners/#{@partner.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key') do
            request.headers["x-api-key"] = "api-key-test"
            get :show, params: { id: @partner.id }
          end
        end
      end

      it 'returns the information about a partner on a hash' do
        partner_response = json_response
        expect(partner_response.dig(:data, :attributes, :name)).to eql @partner.name
      end

      it 'returns env' do
        partner_response = json_response
        expect(partner_response.dig(:data, :attributes, :env)).to eql @partner.env
      end

      it { should respond_with 200 }
    end

    context 'by slug' do
      before(:each) do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/partners/#{@partner.slug}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key') do
            request.headers["x-api-key"] = "api-key-test"
            get :show, params: { id: @partner.slug }
          end
        end
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
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/partners", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          post :create

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    context 'env' do
      it 'sets env to default if not specified' do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/partners", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post :create, params: { data: { attributes: { name: 'foo' } } }
            partner = Partner.find_by_name('foo')
            expect(partner.env).to eq(Environment::PRODUCTION)
          end
        end
      end

      it 'sets env if specified' do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/partners", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post :create, params: { data: { attributes: { name: 'foo', env: 'potato' } } }
            partner = Partner.find_by_name('foo')
            expect(partner.env).to eq('potato')
          end
        end
      end
    end
  end

  describe 'PATCH #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner, env: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/partners/#{@partner.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: { id: @partner.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    context 'env' do
      it "doesn't update env if not specified" do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/partners/#{@partner.id}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            patch :update, params: {
              id: @partner.id, data: { attributes: { answer: 'zonk' } }
            }
            expect(@partner.reload.env).to eq('staging')
          end
        end
      end

      it "updates env if specified" do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/partners/#{@partner.id}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            patch :update, params: {
              id: @partner.id, data: { attributes: { env: Environment::PRODUCTION } }
            }
            expect(@partner.reload.env).to eq(Environment::PRODUCTION)
          end
        end
      end
    end
  end

  describe 'DELETE #partner' do
    before(:each) do
      @partner = FactoryBot.create :partner, env: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/partners/#{@partner.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: { id: @partner.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end
  end
end
