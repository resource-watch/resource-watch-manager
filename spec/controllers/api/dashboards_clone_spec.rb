# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::DashboardsController, type: :controller do
  describe 'POST #dashboard clone endpoint' do
    before(:each) do
      @dashboard = FactoryBot.create :dashboard_with_widgets
    end

    it 'returns 200 OK with the created dashboard data when providing no data in request body (happy case)' do
      VCR.use_cassette('dataset_widget') do
        post 'clone', params: {id: @dashboard.id, loggedUser: USERS[:MANAGER]}
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['id']).to satisfy { |new_id| new_id != @dashboard['id'] }
        expect(json_response['data']['attributes']['slug']).to satisfy { |new_slug| new_slug != @dashboard['slug'] }
        expect(json_response['data']['attributes']['user-id']).to eq(USERS[:MANAGER][:id])

        expect(json_response['data']['attributes']['name']).to eq(@dashboard['name'])
        expect(json_response['data']['attributes']['summary']).to eq(@dashboard['summary'])
        expect(json_response['data']['attributes']['description']).to eq(@dashboard['description'])
        expect(json_response['data']['attributes']['published']).to eq(@dashboard['published'])
        expect(json_response['data']['attributes']['private']).to eq(@dashboard['private'])
        expect(json_response['data']['attributes']['production']).to eq(@dashboard['production'])
        expect(json_response['data']['attributes']['preproduction']).to eq(@dashboard['preproduction'])
        expect(json_response['data']['attributes']['staging']).to eq(@dashboard['staging'])
        expect(json_response['data']['attributes']['application']).to eq(@dashboard['application'])
        expect(json_response['data']['attributes']['is-highlighted']).to eq(@dashboard['is_highlighted'])
        expect(json_response['data']['attributes']['is-featured']).to eq(@dashboard['is_featured'])
      end
    end

    it 'returns 200 OK with the created dashboard data when providing valid data in request body (happy case)' do
      VCR.use_cassette('dataset_widget') do
        new_data = {
          name: 'Cloned dashboard',
          summary: 'Cloned summary',
          description: 'Cloned description',
          published: false,
          private: false,
          production: false,
          preproduction: false,
          staging: false,
        }

        post 'clone', params: {
          id: @dashboard.id,
          loggedUser: USERS[:MANAGER],
          data: { attributes: new_data },
        }

        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['id']).to satisfy { |new_id| new_id != @dashboard['id'] }
        expect(json_response['data']['attributes']['slug']).to satisfy { |new_slug| new_slug != @dashboard['slug'] }

        expect(json_response['data']['attributes']['application']).to eq(@dashboard['application'])
        expect(json_response['data']['attributes']['is-highlighted']).to eq(@dashboard['is_highlighted'])
        expect(json_response['data']['attributes']['is-featured']).to eq(@dashboard['is_featured'])
        expect(json_response['data']['attributes']['user-id']).to eq(USERS[:MANAGER][:id])

        expect(json_response['data']['attributes']['name']).to eq(new_data[:name])
        expect(json_response['data']['attributes']['summary']).to eq(new_data[:summary])
        expect(json_response['data']['attributes']['description']).to eq(new_data[:description])
        expect(json_response['data']['attributes']['published']).to eq(new_data[:published])
        expect(json_response['data']['attributes']['private']).to eq(new_data[:private])
        expect(json_response['data']['attributes']['production']).to eq(new_data[:production])
        expect(json_response['data']['attributes']['preproduction']).to eq(new_data[:preproduction])
        expect(json_response['data']['attributes']['staging']).to eq(new_data[:staging])
      end
    end

    it 'returns 200 OK with valid cloned dashboard (with original values kept) when providing invalid override data in request body' do
      VCR.use_cassette('dataset_widget') do
        new_data = {
          id: '999',
          slug: 'slug',
          user_id: '1',
          is_highlighted: true,
          is_featured: true,
          application: ['fake-app'],
        }

        post 'clone', params: {
          id: @dashboard.id,
          loggedUser: USERS[:MANAGER],
          data: { attributes: new_data },
        }

        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id']).to satisfy { |new_id| new_id != @dashboard['id'] and new_id != new_data[:id] }
        expect(json_response['data']['attributes']['slug']).to satisfy { |new_slug| new_slug != @dashboard['slug'] and new_slug != new_data[:slug] }
        expect(json_response['data']['attributes']['user-id']).to eq(USERS[:MANAGER][:id])
        expect(json_response['data']['attributes']['application']).to eq(@dashboard['application'])
        expect(json_response['data']['attributes']['is-highlighted']).to eq(@dashboard['is_highlighted'])
        expect(json_response['data']['attributes']['is-featured']).to eq(@dashboard['is_featured'])
      end
    end
  end
end
