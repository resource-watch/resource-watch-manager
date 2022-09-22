# frozen_string_literal: true
# == Schema Information
#
# Table name: static_pages
#
#  id                 :bigint           not null, primary key
#  content            :text
#  description        :text
#  env                :text             default("production"), not null
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :bigint
#  photo_updated_at   :datetime
#  published          :boolean
#  slug               :string
#  summary            :text
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_static_pages_on_slug  (slug)
#

# Static page Serializer
class StaticPageSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :content,
             :photo, :slug, :published, :created_at, :updated_at,
             :env

  def photo
    {
      cover: object.photo.url(:cover),
      original: object.photo.url(:original)
    }
  end
end
