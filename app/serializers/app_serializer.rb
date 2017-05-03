# == Schema Information
#
# Table name: apps
#
#  id                     :integer          not null, primary key
#  name                   :string
#  description            :text
#  body                   :text
#  technical_details      :text
#  author                 :string
#  web_url                :string
#  ios_url                :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

# Serializer for App
class AppSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :body, :technical_details, :author,
             :web_url, :ios_url, :thumbnail, :created_at, :updated_at
end
