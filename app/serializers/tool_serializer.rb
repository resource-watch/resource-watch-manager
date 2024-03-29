# frozen_string_literal: true
# == Schema Information
#
# Table name: tools
#
#  id                     :bigint           not null, primary key
#  content                :text
#  description            :string
#  env                    :text             default("production"), not null
#  published              :boolean
#  slug                   :string
#  summary                :string
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :bigint
#  thumbnail_updated_at   :datetime
#  title                  :string
#  url                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

# Tool Serializer
class ToolSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :content, :url,
             :thumbnail, :slug, :published, :created_at, :updated_at,
             :env

  def thumbnail
    {
      medium: object.thumbnail.url(:medium),
      original: object.thumbnail.url(:original)
    }
  end
end
