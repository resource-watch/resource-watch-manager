# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id                  :integer          not null, primary key
#  user_id             :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :profile do
    user_id 'MyString'
    avatar ''
  end
end