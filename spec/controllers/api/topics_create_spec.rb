# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'constants'

describe Api::TopicsController, type: :controller do
  describe 'POST #topics' do
    it 'with no user details should produce a 401 error' do
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

    it 'with role USER should create the topic (happy case)' do
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
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(201)
      sampleTopic = json_response[:data]
      validate_topic_structure(sampleTopic)
      expect(sampleTopic[:attributes][:application]).to eq(['rw'])
    end


    it 'with role USER that doesn\'t belong to rw and no explicit application should produce a 403 error' do
      spoofed_user = USERS[:USER].deep_dup
      spoofed_user[:extraUserData][:apps] = ["fake-app"]

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
        loggedUser: spoofed_user
      }

      expect(response.status).to eq(403)
    end

    it 'with role USER an non-matching applications should produce an 403 error' do
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
        loggedUser: USERS[:USER]
      }

      expect(response.status).to eq(403)
    end

    it 'with role MANAGER should create the topic' do
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
        loggedUser: USERS[:MANAGER]
      }

      expect(response.status).to eq(201)
      sampleTopic = json_response[:data]
      validate_topic_structure(sampleTopic)
      expect(sampleTopic[:attributes][:application]).to eq(['rw'])
    end

    it 'without an application value should create the topic with the default application value' do
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
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)
      sampleTopic = json_response[:data]
      validate_topic_structure(sampleTopic)
      expect(sampleTopic[:attributes][:application]).to eq(%w(rw))
    end

    it 'with multiple application values should create the dashboard with the multiple application values' do
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
        loggedUser: USERS[:ADMIN]
      }

      expect(response.status).to eq(201)
      sampleTopic = json_response[:data]
      validate_topic_structure(sampleTopic)
      expect(sampleTopic[:attributes][:application]).to eq(%w(rw gfw prep))
    end
  end
end
