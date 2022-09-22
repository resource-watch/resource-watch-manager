# frozen_string_literal: true
# == Schema Information
#
# Table name: dashboards
#
#  id                        :bigint           not null, primary key
#  application               :string           default(["\"rw\""]), not null, is an Array
#  author_image_content_type :string
#  author_image_file_name    :string
#  author_image_file_size    :bigint
#  author_image_updated_at   :datetime
#  author_title              :string           default("")
#  content                   :text
#  description               :string
#  env                       :text             default("production"), not null
#  is_featured               :boolean          default(FALSE)
#  is_highlighted            :boolean          default(FALSE)
#  name                      :string
#  photo_content_type        :string
#  photo_file_name           :string
#  photo_file_size           :bigint
#  photo_updated_at          :datetime
#  private                   :boolean          default(TRUE)
#  published                 :boolean
#  slug                      :string
#  summary                   :string
#  user_name                 :string
#  user_role                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :string
#

class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :description,
             :content, :published, :photo, :user_id, :private,
             :env, :user, :application,
             :is_highlighted, :is_featured, :author_title, :author_image

  def photo
    {
      cover: object.photo.url(:cover),
      thumb: object.photo.url(:thumb),
      original: object.photo.url(:original)
    }
  end

  def author_image
    {
      cover: object.author_image.url(:cover),
      thumb: object.author_image.url(:thumb),
      original: object.author_image.url(:original)
    }
  end

  def user
    return unless object.public_methods.include?(:user)

    object.user
  end
end
