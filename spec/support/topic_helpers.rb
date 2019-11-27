require 'spec_helper'

def validate_topic_structure(expected)
  expect(expected).to have_key(:id)
  expect(expected).to have_key(:type)
  expect(expected).to have_key(:attributes)

  expect(expected[:attributes]).to have_key(:name)
  expect(expected[:attributes]).to have_key(:slug)
  expect(expected[:attributes]).to have_key(:summary)
  expect(expected[:attributes]).to have_key(:description)
  expect(expected[:attributes]).to have_key(:content)
  expect(expected[:attributes]).to have_key(:published)
  expect(expected[:attributes]).to have_key(:photo)
  expect(expected[:attributes]).to have_key('user-id'.to_sym)
  expect(expected[:attributes]).to have_key(:private)
  expect(expected[:attributes]).to have_key(:application)
end
