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

  belongs_to :category, inverse_of: :subcategories
  has_many :dataset_subcategories

  # has_many :datasets, through: :dataset_subcategories
  attr_accessor :datasets

  accepts_nested_attributes_for :dataset_subcategories

  validates_presence_of :name

  # Gets the datasets from the API and saves them in @datasets
  def build_datasets
    return unless dataset_subcategories.any?
    datasets = DatasetService.datasets('ids' => dataset_subcategories.map(&:dataset_id).join(','))
    @datasets = []
    datasets.each do |ds|
      @datasets << Dataset.new(ds)
    end
  end

  # Creates the datasets subcategories
  # This hack is needed while ActiveModelAssociations isn't supported in Rails 5.1
  def associate_datasets(ids)
    dataset_subcategories.each do |ds|
      ds.mark_for_destruction unless ids.include?(ds.dataset_id)
    end

    ids.each do |id|
      dataset_subcategories.build(dataset_id: id) unless dataset_subcategories.where(dataset_id: id).any?
    end
  end
end
