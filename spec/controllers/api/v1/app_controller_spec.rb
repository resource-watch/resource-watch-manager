# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::AppsController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @app = FactoryGirl.create :app
      get :show, params: { id: @app.id }
    end

    it 'returns the information about an app on a hash' do
      response = json_response
      expect(response.dig(:data, :attributes, :name)).to eql @app.name
    end
  end


  describe 'GET #index' do
    before(:each) do
      @apps = FactoryGirl.create_list(:app, 4)
      @apps << FactoryGirl.create(:app, name: 'ZZZZ')
    end

    it 'Gets all the apps' do
      get :index
      response = json_response
      expect(response.dig(:data).size).to eql(5)
    end

    it 'Shows a list of apps for the first page' do
      get :index, params: { page: { number: 2, size: 4 } }
      response = json_response
      expect(response.dig(:data).size).to eql(1)
      # TODO: Check this problem
      expect(response.dig(:data)[0][:attributes][:name]).to eql(@apps.last.name)
    end

  end

  describe 'PUT #update' do
    before(:each) do
      @app = FactoryGirl.create(:app)
    end

    it 'Edits an app' do
      name = 'new name'
      put :update, params: {'id' => @app.id, 'app' => {'name' => name } }
      expect(response.status).to eql(200)
    end

  end


  describe 'POST #create' do
    let!(:error) { { errors: [{ status: 422, title: "name can't be blank" }]}}

    it 'Invalid app' do
      post :create, params: { 'app' => { 'name' => '' }}
      expect(response.status).to eq(422)
      expect(response.body).to   eq(error.to_json)
    end

    it 'Valid app' do
      post :create, params: { 'app' => { 'name' => 'test' }}
      expect(response.status).to eq(201)
    end
  end


  describe 'DELETE #destroy' do
    before(:each) do
      @app = FactoryGirl.create(:app)
    end

    it 'Delete app' do
      delete :destroy, params: { 'id' => @app.id }
      expect(response.status).to eql(200)
    end

  end

end
