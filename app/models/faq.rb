# frozen_string_literal: true
# == Schema Information
#
# Table name: faqs
#
#  id         :integer          not null, primary key
#  question   :string           not null
#  answer     :text             not null
#  order      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Model for Partner
class Faq < ApplicationRecord
  validates_presence_of :question
  validates_presence_of :answer

  before_save :check_order

  scope :ordered, ->() { order(order: :asc)}

  def self.reorder(ordered_ids)
    if ordered_ids.size != Faq.all.size
      raise ActiveRecord::RecordInvalid.new
    end
    if ordered_ids.uniq.length != ordered_ids.length
      raise ActiveRecord::RecordInvalid.new
    end
    ActiveRecord::Base.transaction do
      ordered_ids.each_with_index { |id, i| Faq.find(id).update(order: i) }
    end
  end

  # If the order chosen exists already or if it's not present, it adds it to the last position
  def check_order
    return if order.present? && Faq.where(order: order).where.not(id: id).empty?
    self.order = Faq.order(order: :desc).limit(1).first.order + 1.0 rescue 1
  end
end
