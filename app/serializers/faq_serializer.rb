# frozen_string_literal: true
# == Schema Information
#
# Table name: faqs
#
#  id          :bigint           not null, primary key
#  answer      :text             not null
#  environment :text             default("production"), not null
#  order       :integer
#  question    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Faq serializer
class FaqSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer, :order, :environment
end
