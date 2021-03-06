# frozen_string_literal: true

require 'spec_helper'

describe Api::StaticPagesController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @static_pages = FactoryBot.create_list(:static_page, 4)
      @static_pages << FactoryBot.create(:static_page, title: 'ZZZZ')
    end

    it 'Gets all the static pages' do
      get :index
      static_page_response = json_response
      expect(static_page_response.dig(:data).size).to eql(5)
    end
  end

  describe 'GET #show' do
    before(:each) do
      @static_page = FactoryBot.create :static_page
      get :show, params: { id: @static_page.id }
    end

    it 'returns the information about a static page on a hash' do
      static_page_response = json_response
      expect(static_page_response.dig(:data, :attributes, :title)).to eql @static_page.title
    end
  end

  describe 'GET #show by slug' do
    before(:each) do
      @static_page = FactoryBot.create :static_page
      get :show, params: { id: @static_page.slug }
    end

    it 'returns the information about a static_page on a hash' do
      static_page_response = json_response
      expect(static_page_response.dig(:data, :attributes, :title)).to eql @static_page.title
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    let!(:error) { { errors: [{ status: 422, title: "title can't be blank" }] } }

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
  end

  describe 'PUT #update' do
    before(:each) do
      @static_page = FactoryBot.create(:static_page)
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
