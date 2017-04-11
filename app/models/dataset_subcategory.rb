# frozen_string_literal: true

# == Schema Information
#
# Table name: dataset_subcategories
#
#  id             :integer          not null, primary key
#  subcategory_id :integer
#  dataset_id     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Association of Datasets to Subcategories
class DatasetSubcategory < ApplicationRecord
  belongs_to :subcategory
  validates_presence_of :dataset_id

  validates_uniqueness_of :subcategory_id, scope: :dataset_id
end
