# frozen_string_literal: true

ActiveAdmin.register Partner do
  config.per_page = 20
  config.sort_order = 'created_at_desc'

  filter :name
  filter :summary
  filter :contact_name
  filter :contact_email
  filter :body
  filter :website
  filter :partner_type
  filter :published
  filter :featured
  filter :updated_at
  filter :created_at

  controller do
    def permitted_params
      params.permit(:id, partner: %i[name summary contact_name contact_email body published
                                     featured website partner_type logo white_logo icon cover])
    end
  end

  index do
    column :name
    column :summary
    column :contact_name
    column :website
    column :partner_type
    column :featured
    column :published
    column :updates_at
    column :created_at
    actions
  end

  form multipart: true do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :summary
      f.input :contact_name
      f.input :contact_email
      f.input :body
      f.input :published
      f.input :featured
      f.input :website
      f.input :partner_type
      f.input :logo, as: :file, hint: f.object.logo.present? ? \
        image_tag(f.object.logo.url(:medium)) : content_tag(:span, 'No image yet')
      f.input :white_logo, as: :file, hint: f.object.white_logo.present? ? \
        image_tag(f.object.white_logo.url(:medium)) : content_tag(:span, 'No image yet')
      f.input :icon, as: :file, hint: f.object.icon.present? ? \
        image_tag(f.object.icon.url(:thumb)) : content_tag(:span, 'No image yet')
      f.input :cover, as: :file, hint: f.object.cover.present? ? \
        image_tag(f.object.cover.url(:medium)) : content_tag(:span, 'No image yet')
    end
    f.actions
  end

  show do |d|
    attributes_table do
      row :name
      row :slug
      row :summary
      row :contact_name
      row :contact_email
      row :body
      row :published
      row :featured
      row :website
      row :partner_type
      row :logo do
        image_tag(d.logo.url(:medium)) unless d.logo.blank?
      end
      row :white_logo do
        image_tag(d.white_logo.url(:medium)) unless d.white_logo.blank?
      end
      row :icon do
        image_tag(d.icon.url(:thumb)) unless d.icon.blank?
      end
      row :cover do
        image_tag(d.cover.url(:medium)) unless d.cover.blank?
      end
      row :updated_at
      row :created_at
    end
  end
end
