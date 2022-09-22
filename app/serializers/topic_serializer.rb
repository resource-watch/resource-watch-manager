# frozen_string_literal: true
# == Schema Information
#
# Table name: topics
#
#  id                 :bigint           not null, primary key
#  application        :string           default(["\"rw\""]), not null, is an Array
#  content            :text
#  description        :string
#  name               :string
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :bigint
#  photo_updated_at   :datetime
#  private            :boolean          default(TRUE)
#  published          :boolean
#  slug               :string
#  summary            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :string
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
