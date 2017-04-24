# == Schema Information
#
# Table name: subcategories
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#

# Serializer for subcategory
class SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description

  belongs_to :category
  has_many :datasets
end
