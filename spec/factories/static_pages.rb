# frozen_string_literal: true
# == Schema Information
#
# Table name: static_pages
#
#  id                 :bigint           not null, primary key
#  content            :text
#  description        :text
#  env                :text             default("production"), not null
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  published          :boolean
#  slug               :string
#  summary            :text
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_static_pages_on_slug  (slug)
#

FactoryBot.define do
  factory :static_page do
    sequence(:title) { |n| "#{n} #{FFaker::CheesyLingo.title}" }
    summary { FFaker::HealthcareIpsum.paragraph }
    description { FFaker::HealthcareIpsum.paragraph(2) }
    content { FFaker::HTMLIpsum.body }
    published { FFaker::Boolean.sample }


    trait :production do
      env { Environment::PRODUCTION }
    end

    factory :static_page_production, traits: [:production]
  end
end
