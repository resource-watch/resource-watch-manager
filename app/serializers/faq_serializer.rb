# frozen_string_literal: true

# Faq serializer
class FaqSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer, :order
end
