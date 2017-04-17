require 'spec_helper'

describe Api::V1::SubcategoriesController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @subcategory = FactoryGirl.create :subcategory
      get :show, params: { id: @subcategory.id }
    end

    it 'returns the information about a subcategory on a hash' do
      subcategory_response = json_response
      expect(subcategory_response.dig(:data, :attributes, :name)).to eql @subcategory.name
    end

    it { should respond_with 200 }
  end
end
