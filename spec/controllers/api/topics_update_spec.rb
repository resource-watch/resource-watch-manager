# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'PATCH #topic' do
    before(:each) do
      @topic_private_manager = FactoryBot.create :topic_private_manager
    end

    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true
              }
            }
          }

          expect(response.status).to eq(401)
        end
      end
    end

    it 'with role USER should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true
              }
            },
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'with role MANAGER and non-matching applications between request and topic should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "content": "[{\"id\":1511952250652,\"type\":\"widget\",\"content\":{\"widgetId\":\"b9186ce9-78ae-418b-a6d3-d521283ce485\",\"categories\":[]}},...}]",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true,
                "application": [
                  "fake-app"
                ]
              }
            },
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'with role MANAGER and non-matching applications between user and topic should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager_fake_app') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"

          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "content": "[{\"id\":1511952250652,\"type\":\"widget\",\"content\":{\"widgetId\":\"b9186ce9-78ae-418b-a6d3-d521283ce485\",\"categories\":[]}},...}]",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true,
                "application": [
                  "rw"
                ]
              }
            },
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'that doesn\'t belong to the user and with role MANAGER should produce an 403 error' do
      fake_manager = USERS[:MANAGER].clone
      fake_manager[:id] = "123"

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, fake_manager, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager_fake_id') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "content": "[{\"id\":1511952250652,\"type\":\"widget\",\"content\":{\"widgetId\":\"b9186ce9-78ae-418b-a6d3-d521283ce485\",\"categories\":[]}},...}]",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true
              }
            },
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'that belongs to the user and with role MANAGER and at least one matching applications between user and topic should update the topic' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "content": "[{\"id\":1511952250652,\"type\":\"widget\",\"content\":{\"widgetId\":\"b9186ce9-78ae-418b-a6d3-d521283ce485\",\"categories\":[]}},...}]",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true,
                "application": %w(rw gfw)
              }
            },
          }

          expect(response.status).to eq(200)
          sampleTopic = json_response[:data]
          validate_topic_structure(sampleTopic)
          expect(sampleTopic[:attributes][:application]).to eq(%w(rw gfw))
        end
      end
    end

    it 'with role ADMIN should update the topic with the multiple application values even if the user does not own the topic' do
      fake_id_admin = USERS[:ADMIN].clone
      fake_id_admin[:id] = '123'

      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('PATCH', "/api/topics/#{@topic_private_manager[:id]}", {}, fake_id_admin, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin_fake_id') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"

          patch :update, params: {
            id: @topic_private_manager[:id],
            "data": {
              "type": "topics",
              "attributes": {
                "name": "Cities",
                "slug": "cities",
                "summary": "Traditional models of city development can lock us into congestion, sprawl, and inefficient resource use. However, compact, ...",
                "description": "",
                "content": "[{\"id\":1511952250652,\"type\":\"widget\",\"content\":{\"widgetId\":\"b9186ce9-78ae-418b-a6d3-d521283ce485\",\"categories\":[]}},...}]",
                "published": false,
                "photo": {
                  "cover": "/system/topics/photos/data?1523301918",
                  "thumb": "/system/topics/photos/data?1523301918",
                  "original": "/system/topics/photos/data?1523301918"
                },
                "private": true,
                "application": %w(rw gfw prep)
              }
            },
          }

          expect(response.status).to eq(200)
          sampleTopic = json_response[:data]
          validate_topic_structure(sampleTopic)
          expect(sampleTopic[:attributes][:application]).to eq(%w(rw gfw prep))
        end
      end
    end
  end
end
