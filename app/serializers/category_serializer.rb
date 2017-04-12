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

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description
end
