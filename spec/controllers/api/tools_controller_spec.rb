# frozen_string_literal: true

require 'spec_helper'

describe Api::ToolsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_tool = FactoryBot.create(:tool_production)
      @staging_tool = FactoryBot.create(:tool, env: 'staging')
      @preproduction_tool = FactoryBot.create(:tool, env: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: {}
          tool_ids = assigns(:tools).map(&:id)
          expect(tool_ids).to eq([@production_tool.id])
        end
      end
    end

    it 'filters by single env' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools", { env: 'staging' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'staging' }
          tool_ids = assigns(:tools).map(&:id)
          expect(tool_ids).to eq([@staging_tool.id])
        end
      end
    end

    it 'filters by multiple envs' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools", { env: [Environment::PRODUCTION, 'preproduction'].join(',') }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: [Environment::PRODUCTION, 'preproduction'].join(',') }
          tool_ids = assigns(:tools).map(&:id)
          expect(tool_ids).to eq([@production_tool.id, @preproduction_tool.id])
        end
      end
    end

    it 'filters by env with weird spellings' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools", { env: 'STAGing ,,,' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'STAGing ,,,' }
          tool_ids = assigns(:tools).map(&:id)
          expect(tool_ids).to eq([@staging_tool.id])
        end
      end
    end

    it "returns no results if specified env doesn't match anything" do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools", { env: 'pre-production' }, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          get :index, params: { env: 'pre-production' }
          tool_ids = assigns(:tools).map(&:id)
          expect(tool_ids).to eq([])
        end
      end
    end
  end

  describe 'GET #tool' do
    before(:each) { @tool = FactoryBot.create :tool_production }
    context 'by id' do
      before(:each) do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools/#{@tool.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key') do
            request.headers["x-api-key"] = "api-key-test"
            get :show, params: { id: @tool.id }
          end
        end
      end

      it 'returns the information about a tool on a hash' do
        tool_response = json_response
        expect(tool_response.dig(:data, :attributes, :title)).to eql @tool.title
      end

      it 'returns env' do
        tool_response = json_response
        expect(tool_response.dig(:data, :attributes, :env)).to eql @tool.env
      end

      it { should respond_with 200 }
    end

    context 'by slug' do
      before(:each) do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('GET', "/api/tools/#{@tool.slug}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key') do
            request.headers["x-api-key"] = "api-key-test"
            get :show, params: { id: @tool.slug }
          end
        end
      end

      it 'returns the information about a tool on a hash' do
        tool_response = json_response
        expect(tool_response.dig(:data, :attributes, :title)).to eql @tool.title
      end

      it { should respond_with 200 }
    end
  end

  describe 'POST #tool' do
    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/tools", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
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
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/tools", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post :create, params: { data: { attributes: { title: 'foo' } } }
            tool = Tool.find_by_title('foo')
            expect(tool.env).to eq(Environment::PRODUCTION)
          end
        end
      end

      it 'sets env if specified' do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/tools", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            post :create, params: { data: { attributes: { title: 'foo', env: 'potato' } } }
            tool = Tool.find_by_title('foo')
            expect(tool.env).to eq('potato')
          end
        end
      end
    end
  end

  describe 'PATCH #tool' do
    before(:each) do
      @tool = FactoryBot.create :tool, env: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/tools/#{@tool.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: { id: @tool.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end

    context 'env' do
      it "doesn't update env if not specified" do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/tools/#{@tool.id}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            patch :update, params: {
              id: @tool.id, data: { attributes: { answer: 'zonk' } }
            }
            expect(@tool.reload.env).to eq('staging')
          end
        end
      end

      it "updates env if specified" do
        VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/tools/#{@tool.id}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
          VCR.use_cassette('api_key_user_user') do
            request.headers["Authorization"] = "abd"
            request.headers["x-api-key"] = "api-key-test"
            patch :update, params: {
              id: @tool.id, data: { attributes: { env: Environment::PRODUCTION } }
            }
            expect(@tool.reload.env).to eq(Environment::PRODUCTION)
          end
        end
      end
    end
  end

  describe 'DELETE #tool' do
    before(:each) do
      @tool = FactoryBot.create :tool, env: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('DELETE', "/api/tools/#{@tool.id}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          delete :destroy, params: { id: @tool.id }

          expect(response.status).to eq(401)
          expect(response.body).to include "Unauthorized"
        end
      end
    end
  end
end
