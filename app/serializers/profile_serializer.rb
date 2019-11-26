# frozen_string_literal: true
# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint(8)        not null, primary key
#  user_id             :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
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
