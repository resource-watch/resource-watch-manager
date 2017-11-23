# frozen_string_literal: true
# == Schema Information
#
# Table name: tools
#
#  id                     :integer          not null, primary key
#  title                  :string
#  slug                   :string
#  summary                :string
#  description            :string
#  content                :text
#  url                    :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  published              :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

# Tool Serializer
class ToolSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :content, :url,
             :thumbnail, :slug, :published, :created_at, :updated_at

  def thumbnail
    {
      medium: object.thumbnail.url(:medium),
      original: object.thumbnail.url(:original)
    }
  end
end
