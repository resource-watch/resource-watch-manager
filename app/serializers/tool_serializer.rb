# frozen_string_literal: true

# == Schema Information
#
# Table name: static_pages
#
#  id                 :integer          not null, primary key
#  title              :string           not null
#  summary            :text
#  description        :text
#  content            :text
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published          :boolean
#

# Tool Serializer
class ToolSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :content,
             :thumbnail, :slug, :published, :created_at, :updated_at

  def thumbnail
    {
      medium: object.thumbnail.url(:medium),
      original: object.thumbnail.url(:original)
    }
  end
end
