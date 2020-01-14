# frozen_string_literal: true
# == Schema Information
#
# Table name: topics
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  content            :text
#  published          :boolean
#  summary            :string
#  private            :boolean          default(TRUE)
#  user_id            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  application        :string           default(["\"rw\""]), not null, is an Array
#

class TopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :description, :content,
             :published, :photo, :user_id, :private, :user, :application

  def photo
    {
      cover: object.photo.url(:cover),
      thumb: object.photo.url(:thumb),
      medium: object.photo.url(:medium),
      original: object.photo.url(:original)
    }
  end

  def user
    return unless object.public_methods.include?(:user)

    object.user
  end
end
