# frozen_string_literal: true

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

# Model of Subcategories
class Subcategory < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :scoped, scope: :category

  belongs_to :category
  has_many :dataset_subcategories
  validates_presence_of :name
end
