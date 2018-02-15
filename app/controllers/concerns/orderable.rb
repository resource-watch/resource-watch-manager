# frozen_string_literal: true

# app/controllers/concerns/orderable.rb
module Orderable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  # A list of the param names that can be used for ordering the model list
  def ordering_params(params)
    ordering = {}
    if params[:sort]
      sort_order = { '-' => :asc, '+' => :desc }

      sorted_params = params[:sort].split(',')
      sorted_params.each do |attr|
        sort_sign = attr.match?(/\A[+-]/) ? attr.slice!(0) : '+'
        model = controller_name.classify.constantize
        if model.attribute_names.include?(attr)
          ordering[attr] = sort_order[sort_sign]
        end
      end
    end
    ordering
  end
end
