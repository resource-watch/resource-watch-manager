# frozen_string_literal: true

require 'spec_helper'

describe Api::ToolsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_tool = FactoryBot.create(:tool_production)
      @staging_tool = FactoryBot.create(:tool, environment: 'staging')
      @preproduction_tool = FactoryBot.create(:tool, environment: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      get :index, params: {}
      tool_ids = assigns(:tools).map(&:id)
      expect(tool_ids).to eq([@production_tool.id])
    end

    it 'filters by single env' do
      get :index, params: {env: 'staging'}
      tool_ids = assigns(:tools).map(&:id)
      expect(tool_ids).to eq([@staging_tool.id])
    end

    it 'filters by multiple envs' do
      get :index, params: {env: [Environment::PRODUCTION, 'preproduction'].join(',')}
      tool_ids = assigns(:tools).map(&:id)
      expect(tool_ids).to eq([@production_tool.id, @preproduction_tool.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {env: 'STAGing ,,,'}
      tool_ids = assigns(:tools).map(&:id)
      expect(tool_ids).to eq([@staging_tool.id])
    end

    it "returns no results if specified env doesn't match anything" do
      get :index, params: {env: 'pre-production'}
      tool_ids = assigns(:tools).map(&:id)
      expect(tool_ids).to eq([])
    end
  end

  describe 'GET #tool' do
    before(:each) { @tool = FactoryBot.create :tool_production }
    context 'by id' do
      before(:each) do
        get :show, params: {id: @tool.id}
      end

      it 'returns the information about a tool on a hash' do
        tool_response = json_response
        expect(tool_response.dig(:data, :attributes, :title)).to eql @tool.title
      end

      it { should respond_with 200 }
    end

    context 'by slug' do
      before(:each) do
        get :show, params: {id: @tool.slug}
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
      post :create

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    context 'environment' do
      it 'sets environment to default if not specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {title: 'foo'}}}
          tool = Tool.find_by_title('foo')
          expect(tool.environment).to eq(Environment::PRODUCTION)
        end
      end

      it 'sets environment if specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {title: 'foo', environment: 'potato'}}}
          tool = Tool.find_by_title('foo')
          expect(tool.environment).to eq('potato')
        end
      end
    end
  end

  describe 'PATCH #tool' do
    before(:each) do
      @tool = FactoryBot.create :tool, environment: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      patch :update, params: {id: @tool.id}

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    context 'environment' do
      it "doesn't update environment if not specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          patch :update, params: {
            id: @tool.id, data: {attributes: {answer: 'zonk'}}
          }
          expect(@tool.reload.environment).to eq('staging')
        end
      end

      it "updates environment if specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          patch :update, params: {
            id: @tool.id, data: {attributes: {environment: Environment::PRODUCTION}}
          }
          expect(@tool.reload.environment).to eq(Environment::PRODUCTION)
        end
      end
    end
  end

  describe 'DELETE #tool' do
    before(:each) do
      @tool = FactoryBot.create :tool, environment: 'staging'
    end

    it 'with no user details should produce a 401 error' do
      delete :destroy, params: {id: @tool.id}

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end
  end
end
