# frozen_string_literal: true

ActiveAdmin.register Dashboard do
  config.per_page = 20
  config.sort_order = 'created_at_desc'

  filter :name
  filter :description
  filter :content
  filter :published
  filter :summary
  filter :user_id
  filter :private

  controller do
    def permitted_params
      params.permit(:id, dashboard: %i[name description content published summary user_id private photo])
    end
  end

  index do
    column :name
    column :summary
    column :description
    column :user_id
    column :published
    column :private
    column :updates_at
    column :created_at
    actions
  end

  form multipart: true do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :summary
      f.input :description
      f.input :content
      f.input :published
      f.input :private
      f.input :user_id
      f.input :photo, as: :file, hint: f.object.photo.present? ? \
        image_tag(f.object.photo.url(:medium)) : content_tag(:span, 'No image yet')
    end
    f.actions
  end

  show do |d|
    attributes_table do
      row :name
      row :slug
      row :summary
      row :description
      row :content
      row :user_id
      row :published
      row :private
      row :photo do
        image_tag(d.photo.url(:medium)) unless d.photo.blank?
      end
      row :updated_at
      row :created_at
    end
  end
end
