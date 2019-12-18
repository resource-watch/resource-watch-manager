# frozen_string_literal: true
# == Schema Information
#
# Table name: dashboards
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  content            :text
#  published          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  summary            :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :string
#  private            :boolean          default(TRUE)
#  production         :boolean          default(TRUE)
#  preproduction      :boolean          default(FALSE)
#  staging            :boolean          default(FALSE)
#  application        :string           default(["\"rw\""]), not null, is an Array
#  is_highlighted     :boolean          default(FALSE)
#  is_featured        :boolean          default(FALSE)
#

class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :description,
             :content, :published, :photo, :user_id, :private,
             :production, :preproduction, :staging, :user, :application,
             :is_highlighted, :is_featured

  def photo
    {
      cover: object.photo.url(:cover),
      thumb: object.photo.url(:thumb),
      original: object.photo.url(:original)
    }
  end

  def user
    return unless object.public_methods.include?(:user)

    object.user
  end
end
