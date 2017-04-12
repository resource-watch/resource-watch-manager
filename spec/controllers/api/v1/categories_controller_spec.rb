require 'spec_helper'

describe Api::V1::CategoriesController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @category = FactoryGirl.create :category
      get :show, params: { id: @category.id }
    end

    it 'returns the information about a category on a hash' do
      category_response = json_response
      expect(category_response.dig(:data, :attributes, :name)).to eql @category.name
    end

    it { should respond_with 200 }
  end
end
