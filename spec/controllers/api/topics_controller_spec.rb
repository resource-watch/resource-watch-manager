# frozen_string_literal: true

require 'spec_helper'

describe Api::TopicsController, type: :controller do
  describe 'POST #clone' do
    before(:each) do
      FactoryGirl.create :topic_with_widgets
    end
    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: { id: Topic.first.id }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST #clone-dashboard' do
    before(:each) do
      FactoryGirl.create :topic_with_widgets
    end
    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone_dashboard', params: { id: Topic.first.id }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #index' do
    before(:each) do
      FactoryGirl.create :topic_private_user_1
      FactoryGirl.create :topic_not_private_user_1
      FactoryGirl.create :topic_private_user_2
      FactoryGirl.create :topic_not_private_user_2
    end

    it 'should return all topics' do
      get :index

      expect(response.status).to eq(200)
      expect(json_response[:data].size).to eq(4)
    end

    it 'should filter only not private' do
      get :index, params: { filter: { private: false } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'should filter only user' do
      get :index, params: { filter: { user: '123abc' } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(['123abc'])
    end

    it 'should filter only private by user' do
      get :index, params: { filter: { user: '123abc', private: true } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['123abc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([true])
    end

    it 'should filter only not private by user' do
      get :index, params: { filter: { user: '123abc', private: false } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['123abc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([false])
    end

    it 'should filter only published and not private' do
      get :index, params: { filter: { published: 'true', private: false } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'should return in json api format' do
      get :index

      body = json_response
      record = body[:data].first

      body.should include(:data)
      record.should include(:id)
      record.should include(:type)
      record.should include(:attributes)

      expect(body[:data]).to be_a(Array)
      expect(record.keys.size).to eq(3)
    end
  end

  describe 'GET #show' do
    before(:each) do
      @topic = FactoryGirl.create :topic_private_user_1
    end

    it 'should return the information from this id' do
      get :show, params: { id: @topic.id }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data).to be_a(Hash)
      expect(json_response[:data][:attributes][:name]).to eq(@topic.name)
    end

    it 'should return in json api format' do
    end
  end
end
