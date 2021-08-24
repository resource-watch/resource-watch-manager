# frozen_string_literal: true

require 'spec_helper'

describe Api::StaticPagesController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @production_static_page = FactoryBot.create(:static_page_production)
      @staging_static_page = FactoryBot.create(:static_page, env: 'staging')
      @preproduction_static_page = FactoryBot.create(:static_page, env: 'preproduction')
    end

    it 'filters by production env when no env filter specified' do
      get :index, params: {}
      static_page_ids = assigns(:static_pages).map(&:id)
      expect(static_page_ids).to eq([@production_static_page.id])
    end

    it 'filters by single env' do
      get :index, params: {env: 'staging'}
      static_page_ids = assigns(:static_pages).map(&:id)
      expect(static_page_ids).to eq([@staging_static_page.id])
    end

    it 'filters by multiple envs' do
      get :index, params: {env: [Environment::PRODUCTION, 'preproduction'].join(',')}
      static_page_ids = assigns(:static_pages).map(&:id)
      expect(static_page_ids).to eq([@production_static_page.id, @preproduction_static_page.id])
    end

    it 'filters by env with weird spellings' do
      get :index, params: {env: 'STAGing ,,,'}
      static_page_ids = assigns(:static_pages).map(&:id)
      expect(static_page_ids).to eq([@staging_static_page.id])
    end

    it "returns no results if specified env doesn't match anything" do
      get :index, params: {env: 'pre-production'}
      static_page_ids = assigns(:static_pages).map(&:id)
      expect(static_page_ids).to eq([])
    end
  end

  describe 'GET #show' do
    before(:each) { @static_page = FactoryBot.create :static_page_production }
    context 'by id' do
      before(:each) do
        get :show, params: { id: @static_page.id }
      end

      it 'returns the information about a static page on a hash' do
        static_page_response = json_response
        expect(static_page_response.dig(:data, :attributes, :title)).to eql @static_page.title
      end

      it 'returns env' do
        static_page_response = json_response
        expect(static_page_response.dig(:data, :attributes, :env)).to eql @static_page.env
      end

      it { should respond_with 200 }
    end

    context 'by slug' do
      before(:each) do
        get :show, params: { id: @static_page.slug }
      end

      it 'returns the information about a static_page on a hash' do
        static_page_response = json_response
        expect(static_page_response.dig(:data, :attributes, :title)).to eql @static_page.title
      end

      it { should respond_with 200 }
    end
  end

  describe 'POST #create' do
    it 'with no user details should produce a 401 error' do
      post :create

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    it 'Valid static page' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        post :create, params: { 'data' => { 'attributes': { 'title' => 'test' } } }
        expect(response.status).to eq(201)
      end
    end

    context 'env' do
      it 'sets env to default if not specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {title: 'foo'}}}
          static_page = StaticPage.find_by_title('foo')
          expect(static_page.env).to eq(Environment::PRODUCTION)
        end
      end

      it 'sets env if specified' do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          post :create, params: {data: {attributes: {title: 'foo', env: 'potato'}}}
          static_page = StaticPage.find_by_title('foo')
          expect(static_page.env).to eq('potato')
        end
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @static_page = FactoryBot.create(:static_page, env: 'staging')
    end

    it 'with no user details should produce a 401 error' do
      title = 'new title'
      put :update, params: { 'id' => @static_page.id, 'data' => { 'attributes': { 'title' => title } } }

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    it 'Edits a static page' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        title = 'new title'
        put :update, params: { 'id' => @static_page.id, 'data' => { 'attributes': { 'title' => title } } }
        expect(response.status).to eql(200)
      end
    end

    context 'env' do
      it "doesn't update env if not specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          put :update, params: {
            id: @static_page.id, data: {attributes: {answer: 'zonk'}}
          }
          expect(@static_page.reload.env).to eq('staging')
        end
      end

      it "updates env if specified" do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          put :update, params: {
            id: @static_page.id, data: {attributes: {env: Environment::PRODUCTION}}
          }
          expect(@static_page.reload.env).to eq(Environment::PRODUCTION)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @static_page = FactoryBot.create(:static_page)
    end

    it 'with no user details should produce a 401 error' do
      delete :destroy, params: {
        id: @static_page[:id]
      }

      expect(response.status).to eq(401)
      expect(response.body).to include "Unauthorized"
    end

    it 'Delete valid page' do
      VCR.use_cassette('user_admin') do
        request.headers["Authorization"] = "abd"
        delete :destroy, params: { 'id' => @static_page.id }
        expect(response.status).to eql(204)
      end
    end
  end
end
