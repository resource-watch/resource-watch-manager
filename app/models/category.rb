# frozen_string_literal: true

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

# Category Model
class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i(slugged)

  has_many :subcategories, inverse_of: :category
  validates_presence_of :name
end
