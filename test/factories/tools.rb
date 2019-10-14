# frozen_string_literal: true

# == Schema Information
#
# Table name: tools
#
#  id                     :integer          not null, primary key
#  title                  :string
#  slug                   :string
#  summary                :string
#  description            :string
#  content                :text
#  url                    :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  published              :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :tool do
    title { 'MyString' }
    slug { 'MyString' }
    summary { 'MyString' }
    description { 'MyString' }
    content { 'MyText' }
    url { 'MyString' }
    thumbnail { '' }
    published { false }
  end
end
