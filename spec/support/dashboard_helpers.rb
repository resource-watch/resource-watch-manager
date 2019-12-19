require 'spec_helper'

def validate_dashboard_structure(expected)
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
  expect(expected[:attributes]).to have_key(:production)
  expect(expected[:attributes]).to have_key(:preproduction)
  expect(expected[:attributes]).to have_key(:staging)
  expect(expected[:attributes]).to have_key(:user)
  expect(expected[:attributes]).to have_key(:application)
  expect(expected[:attributes]).to have_key('is-highlighted'.to_sym)
  expect(expected[:attributes]).to have_key('is-featured'.to_sym)
end
