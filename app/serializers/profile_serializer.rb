# frozen_string_literal: true

# == Schema Information
#
# Table name: static_pages
#
#  user_id             :string          not null, primary key
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  published           :boolean
#

# Profile Serializer
class ProfileSerializer < ActiveModel::Serializer
  attributes :user_id, :avatar, :created_at, :updated_at

  def avatar
    {
      thumbnail: object.avatar.url(:thumbnail),
      medium: object.avatar.url(:medium),
      original: object.avatar.url(:original)
    }
  end
end
