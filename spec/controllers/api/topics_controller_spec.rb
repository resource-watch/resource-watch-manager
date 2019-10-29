# frozen_string_literal: true

require 'spec_helper'

describe Api::TopicsController, type: :controller do
  describe 'POST #clone' do
    before(:each) do
      FactoryBot.create :topic_with_widgets
    end
    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {id: Topic.first.id}
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST #clone-dashboard' do
    before(:each) do
      FactoryBot.create :topic_with_widgets
    end
    it 'should perform the cloning' do
      VCR.use_cassette('dataset_widget') do
        post 'clone_dashboard', params: {id: Topic.first.id}
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #index' do
    before(:each) do
      FactoryBot.create :topic_private_user_1
      FactoryBot.create :topic_not_private_user_1
      FactoryBot.create :topic_private_user_2
      FactoryBot.create :topic_not_private_user_2
    end

    it 'should return all topics' do
      get :index

      expect(response.status).to eq(200)
      expect(json_response[:data].size).to eq(4)
    end

    it 'with private=false filter should return only non-private topics' do
      get :index, params: {private: false}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with user=<userId> filter should return only topics associated with that user' do
      get :index, params: {user: '57a1ff091ebc1ad91d089bdc'}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with user=<userId> and private=true filters should return only private topics associated with that user' do
      get :index, params: {user: '57a1ff091ebc1ad91d089bdc', private: true}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([true])
    end

    it 'with user=<userId> and private=false filters should return only non-private topics associated with that user' do
      get :index, params: {user: '57a1ff091ebc1ad91d089bdc', private: false}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([false])
    end

    it 'with published=true and private=false filters should return only non-private, published topics' do
      get :index, params: {published: 'true', private: false}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'should return response in json api format' do
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

  # Deprecated: this section tests filtering using the `filters[]` approach, which is deprecated. Use root level filters instead
  describe 'GET #index using deprecated `filters` param' do
    before(:each) do
      FactoryBot.create :topic_private_user_1
      FactoryBot.create :topic_not_private_user_1
      FactoryBot.create :topic_private_user_2
      FactoryBot.create :topic_not_private_user_2
    end

    it 'with filter[private]=false filter should return only non-private topics' do
      get :index, params: {filter: {private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with filter[user]=<userId> filter should return only topics associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc'}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with filter[user]=<userId> and filter[private]=true filters should return only private topics associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc', private: true}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([true])
    end

    it 'with filter[user]=<userId> and filter[private]=false filters should return only non-private topics associated with that user' do
      get :index, params: {filter: {user: '57a1ff091ebc1ad91d089bdc', private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([false])
    end

    it 'with filter[published]=true and filter[private]=false filters should return only non-private, published topics' do
      get :index, params: {filter: {published: 'true', private: false}}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end
  end

  describe 'GET #show' do
    before(:each) do
      @topic = FactoryBot.create :topic_private_user_1
    end

    it 'should return the information from this id' do
      get :show, params: {id: @topic.id}

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data).to be_a(Hash)
      expect(json_response[:data][:attributes][:name]).to eq(@topic.name)
    end

    it 'should return in json api format' do
    end
  end
end
