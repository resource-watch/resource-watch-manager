# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::InsightsController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @insight = FactoryGirl.create :insight
      get :show, params: { id: @insight.id }
    end

    it 'returns the information about a insight on a hash' do
      insight_response = json_response
      expect(insight_response.dig(:data, :attributes, :title)).to eql @insight.title
    end
  end


  describe 'GET #index' do
    before(:each) do
      @insights = FactoryGirl.create_list(:insight, 4)
      @insights << FactoryGirl.create(:insight, title: 'ZZZZ')
    end

    it 'Gets all the insights' do
      get :index
      insights_response = json_response
      expect(insights_response.dig(:data).size).to eql(5)
    end

    it 'Shows a list of insights for the first page' do
      get :index, params: { page: { number: 2, size: 4 } }
      insights_response = json_response
      expect(insights_response.dig(:data).size).to eql(1)
      # TODO: Check this problem
      expect(insights_response.dig(:data)[0][:attributes][:title]).to eql(@insights.last.title)
    end

  end

  describe 'PUT #update' do
    before(:each) do
      @insight = FactoryGirl.create(:insight)
    end

    it 'Edits an insight' do
      title = 'new title'
      put :update, params: {'id' => @insight.id, 'insight' => {'title' => title } }
      expect(response.status).to eql(200)
    end

  end


  describe 'POST #create' do
    let!(:error) { { errors: [{ status: 422, title: "title can't be blank" }]}}

    it 'Invalid insight' do
      post :create, params: { 'insight' => { 'title' => '' }}
      expect(response.status).to eq(422)
      expect(response.body).to   eq(error.to_json)
    end

    it 'Valid insight' do
      post :create, params: { 'insight' => { 'title' => 'test' }}
      expect(response.status).to eq(201)
    end
  end


  describe 'DELETE #destroy' do
    before(:each) do
      @insight = FactoryGirl.create(:insight)
    end

    it 'Delete insight' do
      delete :destroy, params: {'id' => @insight.id }
      expect(response.status).to eql(200)
    end

  end

end
