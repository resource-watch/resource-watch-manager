# == Schema Information
#
# Table name: tools
#
#  id                     :bigint           not null, primary key
#  content                :text
#  description            :string
#  env                    :text             default("production"), not null
#  published              :boolean
#  slug                   :string
#  summary                :string
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  title                  :string
#  url                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :tool do
    title { FFaker::Name.name }
    summary { FFaker::Lorem.paragraph }
    description { FFaker::Lorem.paragraph }
    content { FFaker::Lorem.paragraph }
    url { FFaker::Internet.http_url }
    published { FFaker::Boolean.sample }

    trait :production do
      env { Environment::PRODUCTION }
    end

    factory :tool_production, traits: [:production]
  end
end
