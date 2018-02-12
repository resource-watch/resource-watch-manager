# frozen_string_literal: true

# == Schema Information
#
# Table name: dashboards
#
#  id                 :integer          not null, primary key
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
#

FactoryGirl.define do
  factory :dashboard_private_user_1, class: Dashboard do
    name { FFaker::Name.name }
    published true
    user_id '123abc'
    private true
  end

  factory :dashboard_not_private_user_1, class: Dashboard do
    name { FFaker::Name.name }
    published true
    user_id '123abc'
    private false
  end

  factory :dashboard_private_user_2, class: Dashboard do
    name { FFaker::Name.name }
    published true
    user_id '4a5b6c'
    private true
  end

  factory :dashboard_not_private_user_2, class: Dashboard do
    name { FFaker::Name.name }
    published true
    user_id '4a5b6c'
    private false
  end
end
