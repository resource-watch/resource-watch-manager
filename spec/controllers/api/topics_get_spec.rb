# frozen_string_literal: true

require 'spec_helper'

describe Api::TopicsController, type: :controller do
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

      sampleTopic = json_response[:data][0]
      validate_topic_structure(sampleTopic)
    end

    it 'with private=false filter should return only non-private topics' do
      get :index, params: { private: false }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with user=<userId> filter should return only topics associated with that user' do
      get :index, params: { user: '57a1ff091ebc1ad91d089bdc' }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with user=<userId> and private=true filters should return only private topics associated with that user' do
      get :index, params: { user: '57a1ff091ebc1ad91d089bdc', private: true }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([true])
    end

    it 'with user=<userId> and private=false filters should return only non-private topics associated with that user' do
      get :index, params: { user: '57a1ff091ebc1ad91d089bdc', private: false }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([false])
    end

    it 'with published=true and private=false filters should return only non-private, published topics' do
      get :index, params: { published: 'true', private: false }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with includes=user while not being logged in should return dashboards including user name, email and photo' do
      VCR.use_cassette("include_user") do
        get :index, params: { includes: 'user' }

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(4)
        expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
        data.each do |dashboard|
          expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo])
          expect(dashboard[:attributes][:user][:photo]).to be_url()
        end
      end
    end

    it 'with includes=user while being logged in as USER should return dashboards including user name, email and photo' do
      VCR.use_cassette("include_user") do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
          data.each do |dashboard|
            expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo])
            expect(dashboard[:attributes][:user][:photo]).to be_url()
          end
        end
      end
    end

    it 'with includes=user while being logged in as MANAGER should return dashboards including user name, email and photo' do
      VCR.use_cassette("include_user") do
        VCR.use_cassette('user_manager') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
          data.each do |dashboard|
            expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo])
            expect(dashboard[:attributes][:user][:photo]).to be_url()
          end
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return dashboards including user name, email, photo and role' do
      VCR.use_cassette("include_user") do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])
          data.each do |dashboard|
            expect(dashboard[:attributes][:user].keys).to eq([:name, :email, :photo, :role])
            expect(dashboard[:attributes][:user][:photo]).to be_url()
          end
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return dashboards including user name, email, photo and role, even if only partial data is available' do
      VCR.use_cassette("include_user_partial") do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)

          responseDatasetOne = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '57a1ff091ebc1ad91d089bdc' }
          responseDatasetTwo = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c143429f8d19932db9d06ea' }
          responseDatasetThree = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c069855ccc46a6660a4be68' }

          expect(data.map { |dashboard| dashboard[:attributes][:user].length }.uniq).not_to eq([0])

          expect(responseDatasetOne[:attributes][:user][:name]).to eq('John Doe')
          expect(responseDatasetOne[:attributes][:user][:role]).to eq('ADMIN')
          expect(responseDatasetOne[:attributes][:user][:email]).to eq('john.doe@vizzuality.com')
          expect(responseDatasetOne[:attributes][:user][:photo]).to be_url()

          expect(responseDatasetTwo[:attributes][:user][:name]).to eq(nil)
          expect(responseDatasetTwo[:attributes][:user][:role]).to eq('USER')
          expect(responseDatasetTwo[:attributes][:user][:email]).to eq('jane.poe@vizzuality.com')
          expect(responseDatasetTwo[:attributes][:user][:photo]).to be_url()

          expect(responseDatasetThree[:attributes][:user][:name]).to eq('mark')
          expect(responseDatasetThree[:attributes][:user][:role]).to eq('USER')
          expect(responseDatasetThree[:attributes][:user][:email]).to eq(nil)
          expect(responseDatasetThree[:attributes][:user][:photo]).to be_url()
        end
      end
    end

    it 'with includes=user while not being logged in should return topics including user name, email and photo' do
      VCR.use_cassette("include_user") do
        get :index, params: { includes: 'user' }

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(4)
        expect(data.map { |topic| topic[:attributes][:user].length }.uniq).not_to eq([0])
        data.each do |topic|
          expect(topic[:attributes][:user].keys).to eq([:name, :email, :photo])
          expect(topic[:attributes][:user][:photo]).to be_url()
        end
      end
    end

    it 'with includes=user while being logged in as USER should return topics including user name, email and photo' do
      VCR.use_cassette("include_user") do
        VCR.use_cassette('user_user') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |topic| topic[:attributes][:user].length }.uniq).not_to eq([0])
          data.each do |topic|
            expect(topic[:attributes][:user].keys).to eq([:name, :email, :photo])
            expect(topic[:attributes][:user][:photo]).to be_url()
          end
        end
      end
    end

    it 'with includes=user while being logged in as MANAGER should return topics including user name, email and photo' do
      VCR.use_cassette("include_user") do
        VCR.use_cassette('user_manager') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |topic| topic[:attributes][:user].length }.uniq).not_to eq([0])
          data.each do |topic|
            expect(topic[:attributes][:user].keys).to eq([:name, :email, :photo])
            expect(topic[:attributes][:user][:photo]).to be_url()
          end
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return topics including user name, email, photo and role' do
      VCR.use_cassette("include_user") do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)
          expect(data.map { |topic| topic[:attributes][:user].length }.uniq).not_to eq([0])
          data.each do |topic|
            expect(topic[:attributes][:user].keys).to eq([:name, :email, :photo, :role])
            expect(topic[:attributes][:user][:photo]).to be_url()
          end
        end
      end
    end

    it 'with includes=user while being logged in as ADMIN should return topics including user name, email, photo and role, even if only partial data is available' do
      VCR.use_cassette("include_user_partial") do
        VCR.use_cassette('user_admin') do
          request.headers["Authorization"] = "abd"
          get :index, params: { includes: 'user' }

          data = json_response[:data]

          expect(response.status).to eq(200)
          expect(data.size).to eq(4)

          responseDatasetOne = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '57a1ff091ebc1ad91d089bdc' }
          responseDatasetTwo = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c143429f8d19932db9d06ea' }
          responseDatasetThree = data.find { |dataset| dataset[:attributes]['user-id'.to_sym] == '5c069855ccc46a6660a4be68' }

          expect(data.map { |topic| topic[:attributes][:user].length }.uniq).not_to eq([0])

          expect(responseDatasetOne[:attributes][:user][:name]).to eq('John Doe')
          expect(responseDatasetOne[:attributes][:user][:role]).to eq('ADMIN')
          expect(responseDatasetOne[:attributes][:user][:email]).to eq('john.doe@vizzuality.com')
          expect(responseDatasetOne[:attributes][:user][:photo]).to be_url()

          expect(responseDatasetTwo[:attributes][:user][:name]).to eq(nil)
          expect(responseDatasetTwo[:attributes][:user][:role]).to eq('USER')
          expect(responseDatasetTwo[:attributes][:user][:email]).to eq('jane.poe@vizzuality.com')
          expect(responseDatasetTwo[:attributes][:user][:photo]).to be_url()

          expect(responseDatasetThree[:attributes][:user][:name]).to eq('mark')
          expect(responseDatasetThree[:attributes][:user][:role]).to eq('USER')
          expect(responseDatasetThree[:attributes][:user][:email]).to eq(nil)
          expect(responseDatasetThree[:attributes][:user][:photo]).to be_url()
        end
      end
    end

    it 'with filter by a single application value should return topics that belong to at least that application' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: { application: 'rw' }

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(3)
        expect(data.map { |topic| topic[:attributes][:application] }.uniq).to eq([['rw'], %w(rw gfw)])
      end
    end

    it 'with filter by an array with a single application value should return topics without being filtered (multiple filter values not supported)' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: { application: ['rw'] }

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(4)
      end
    end

    it 'with filter by multiple application should return topics without being filtered (multiple filter values not supported)' do
      VCR.use_cassette("get_users_by_role_admin") do
        get :index, params: { application: %w(rw gfw) }

        data = json_response[:data]

        expect(response.status).to eq(200)
        expect(data.size).to eq(4)
      end
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
      get :index, params: { filter: { private: false } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end

    it 'with filter[user]=<userId> filter should return only topics associated with that user' do
      get :index, params: { filter: { user: '57a1ff091ebc1ad91d089bdc' } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }.uniq).to eq(['57a1ff091ebc1ad91d089bdc'])
    end

    it 'with filter[user]=<userId> and filter[private]=true filters should return only private topics associated with that user' do
      get :index, params: { filter: { user: '57a1ff091ebc1ad91d089bdc', private: true } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([true])
    end

    it 'with filter[user]=<userId> and filter[private]=false filters should return only non-private topics associated with that user' do
      get :index, params: { filter: { user: '57a1ff091ebc1ad91d089bdc', private: false } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(1)
      expect(data.map { |topic| topic[:attributes][:"user-id"] }).to eq(['57a1ff091ebc1ad91d089bdc'])
      expect(data.map { |topic| topic[:attributes][:private] }).to eq([false])
    end

    it 'with filter[published]=true and filter[private]=false filters should return only non-private, published topics' do
      get :index, params: { filter: { published: 'true', private: false } }

      data = json_response[:data]

      expect(response.status).to eq(200)
      expect(data.size).to eq(2)
      expect(data.map { |topic| topic[:attributes][:published] }.uniq).to eq([true])
      expect(data.map { |topic| topic[:attributes][:private] }.uniq).to eq([false])
    end
  end
end
