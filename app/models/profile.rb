# frozen_string_literal: true
# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint           not null, primary key
#  avatar_content_type :string
#  avatar_file_name    :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :string
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ApplicationRecord
  has_attached_file :avatar, styles: { medium: '300x>', thumbnail: '100x>' }
  validates_attachment_content_type :avatar, content_type: %r{^image\/.*}
  do_not_validate_attachment_file_type :avatar

  validates_presence_of :user_id
  validates_presence_of :avatar
end
