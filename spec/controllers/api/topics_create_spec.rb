# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'POST #topics' do
    it 'with no user details should produce a 401 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, nil, APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key') do
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
                "private": true
              }
            }
          }

          expect(response.status).to eq(401)
        end
      end
    end

    it 'with role USER should create the topic (happy case)' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
                "private": true
              }
            },
          }

          expect(response.status).to eq(201)
          sample_topic = json_response[:data]
          validate_topic_structure(sample_topic)
          expect(sample_topic[:attributes][:application]).to eq(['rw'])
        end
      end
    end

    it 'with role USER that doesn\'t belong to rw and no explicit application should produce a 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user_fake_app') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
                "private": true
              }
            },
          }

          expect(response.status).to eq(403)
        end
      end
    end

    it 'with role USER an non-matching applications should produce an 403 error' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, USERS[:USER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_user') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
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

    it 'with role MANAGER should create the topic' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, USERS[:MANAGER], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_manager') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
                "private": true,
                "application": [
                  "rw"
                ]
              }
            },
          }

          expect(response.status).to eq(201)
          sample_topic = json_response[:data]
          validate_topic_structure(sample_topic)
          expect(sample_topic[:attributes][:application]).to eq(['rw'])
        end
      end
    end

    it 'without an application value should create the topic with the default application value' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
                "private": true
              }
            },
          }

          expect(response.status).to eq(201)
          sample_topic = json_response[:data]
          validate_topic_structure(sample_topic)
          expect(sample_topic[:attributes][:application]).to eq(%w(rw))
        end
      end
    end

    it 'with multiple application values should create the dashboard with the multiple application values' do
      VCR.use_cassette('aws_logging', :erb => { message: mock_aws_request_log_message('POST', "/api/topics", {}, USERS[:ADMIN], APPLICATION) }, :match_requests_on => [rw_api_auth_headers, :method, :uri, :query, body_without_timestamp]) do
        VCR.use_cassette('api_key_user_admin') do
          request.headers["Authorization"] = "abd"
          request.headers["x-api-key"] = "api-key-test"
          post :create, params: {
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
                "user-id": "eb63867922e16e34ef3ce862",
                "private": true,
                "application": %w(rw gfw prep)
              }
            },
          }

          expect(response.status).to eq(201)
          sample_topic = json_response[:data]
          validate_topic_structure(sample_topic)
          expect(sample_topic[:attributes][:application]).to eq(%w(rw gfw prep))
        end
      end
    end
  end
end
