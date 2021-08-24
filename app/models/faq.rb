# frozen_string_literal: true
# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text             not null
#  env        :text             default("production"), not null
#  order      :integer
#  question   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Model for Partner
class Faq < ApplicationRecord
  include Environment

  validates_presence_of :question
  validates_presence_of :answer

  before_save :check_order

  scope :ordered, ->() { order(order: :asc) }

  def self.reorder(ordered_ids)
    raise ActiveRecord::RecordInvalid if ordered_ids.size != Faq.all.size
    if ordered_ids.uniq.length != ordered_ids.length
      raise ActiveRecord::RecordInvalid
    end
    ActiveRecord::Base.transaction do
      ordered_ids.each_with_index { |id, i| Faq.find(id).update_column(:order, i) }
    end
  end

  # If the order chosen exists already or if it's not present, it adds it to the last position
  def check_order
    return if order.present? && Faq.where(order: order).where.not(id: id).empty?
    self.order = begin
                   Faq.order(order: :desc).limit(1).first.order + 1.0
                 rescue
                   1
                 end
  end
end
