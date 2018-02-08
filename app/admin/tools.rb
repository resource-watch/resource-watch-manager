# frozen_string_literal: true

ActiveAdmin.register Tool do
  config.per_page = 20
  config.sort_order = 'created_at_desc'

  filter :title
  filter :summary
  filter :description
  filter :content
  filter :url
  filter :published
  filter :updated_at
  filter :created_at

  controller do
    def permitted_params
      params.permit(:id, tool: %i[title summary description
                                  content url published thumbnail])
    end
  end

  index do
    column :title
    column :summary
    column :description
    column :url
    column :published
    column :updated_at
    column :created_at
    actions
  end

  form multipart: true do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :title
      f.input :summary
      f.input :description
      f.input :content
      f.input :url
      f.input :published
      f.input :thumbnail, as: :file, hint: f.object.thumbnail.present? ? \
        image_tag(f.object.thumbnail.url(:medium)) : content_tag(:span, 'No image yet')
    end
    f.actions
  end

  show do |d|
    attributes_table do
      row :title
      row :slug
      row :summary
      row :description
      row :content
      row :url
      row :published
      row :thumbnail do
        image_tag(d.thumbnail.url(:medium)) unless d.thumbnail.blank?
      end
      row :updated_at
      row :created_at
    end
  end
end
