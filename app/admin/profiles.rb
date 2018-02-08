# frozen_string_literal: true

ActiveAdmin.register Profile do
  config.per_page = 20
  config.sort_order = 'created_at_desc'

  filter :user_id
  filter :updated_at
  filter :created_at

  controller do
    def permitted_params
      params.permit(:id, profile: %i[user_id avatar])
    end
  end

  index do
    column :user_id
    column :updated_at
    column :created_at
    actions
  end

  form multipart: true do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :user_id
      f.input :avatar, as: :file, hint: f.object.avatar.present? ? \
        image_tag(f.object.avatar.url(:medium)) : content_tag(:span, 'No image yet')
    end
    f.actions
  end

  show do |d|
    attributes_table do
      row :user_id
      row :avatar do
        image_tag(d.avatar.url(:medium)) unless d.avatar.blank?
      end
      row :updated_at
      row :created_at
    end
  end
end
