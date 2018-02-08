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

end
