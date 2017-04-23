# frozen_string_literal: true

require 'spec_helper'


describe Api::V1::StaticPagesController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @static_page = FactoryGirl.create :static_page
      get :show, params: { id: @static_page.id }
    end

    it 'returns the information about a static page on a hash' do
      static_page_response = json_response
      expect(static_page_response.dig(:data, :attributes, :title)).to eql @static_page.title
    end

  end

  describe 'GET #index' do
    before(:each) do
      @static_pages = FactoryGirl.create_list(:static_page, 4)
    end

    it 'Gets all the static pages' do
      get :index
      static_page_response = json_response
      expect(static_page_response.dig(:data).size).to eql(4)
    end

    it 'Shows a list of static pages for the first page' do
      get :index, params: { page: {number: 2, size: 2 }}
      static_page_response = json_response
      expect(static_page_response.dig(:data).size).to eql(2)
      # TODO -> Check this problem
      expect(static_page_response.dig(:data)[0][:attributes][:title]).to start_with('3')
    end


  end

  describe 'PUT #update' do
    before(:each) do
      @static_page = FactoryGirl.create(:static_page)
    end

    it 'Edits a static page' do
      title = 'new title'
      put :update, params: {'id' => @static_page.id, 'static_page' => {'title' => title} }
      static_page_response = json_response
      expect(response.status).to eql(200)
    end

  end


  describe 'POST #create' do
    let!(:error) { { errors: [{ status: 422, title: "title can't be blank" }]}}

    it 'Invalid static page' do
      post :create, params: { 'static_page' => { 'title' => '' }}
      expect(response.status).to eq(422)
      expect(response.body).to   eq(error.to_json)
    end

    it 'Valid static page' do
      post :create, params: { 'static_page' => { 'title' => 'test' }}
      expect(response.status).to eq(201)
    end
  end


  describe 'DELETE #destroy' do
    before(:each) do
      @static_page = FactoryGirl.create(:static_page)
    end

    it 'Delete valid page' do
      delete :destroy, params: {'id' => @static_page.id }
      expect(response.status).to eql(200)
    end

  end
end
