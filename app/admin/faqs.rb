# frozen_string_literal: true

ActiveAdmin.register Faq do
  config.per_page = 20
  config.sort_order = 'created_at_desc'

  filter :question
  filter :answer

  controller do
    def permitted_params
      params.permit(:question, :answer, :order)
    end
  end

end
