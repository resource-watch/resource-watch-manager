# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Serializer for Category
class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description#, :subcategories

  has_many :subcategories

  # Serializer for the Category's Subcategories
  class SubcategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :slug
  end
end
