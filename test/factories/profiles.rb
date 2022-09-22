# frozen_string_literal: true
# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint           not null, primary key
#  avatar_content_type :string
#  avatar_file_name    :string
#  avatar_file_size    :bigint
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :string
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

FactoryBot.define do
  factory :profile do
    user_id { 'MyString' }
    avatar { '' }
  end
end
