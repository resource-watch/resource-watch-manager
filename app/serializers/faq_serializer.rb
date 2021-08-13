# frozen_string_literal: true
# == Schema Information
#
# Table name: faqs
#
#  id         :bigint(8)        not null, primary key
#  question   :string           not null
#  answer     :text             not null
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Faq serializer
class FaqSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer, :order, :environment
end
