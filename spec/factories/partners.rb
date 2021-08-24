# frozen_string_literal: true
# == Schema Information
#
# Table name: partners
#
#  id                      :integer          not null, primary key
#  body                    :text
#  contact_email           :string
#  contact_name            :string
#  cover_content_type      :string
#  cover_file_name         :string
#  cover_file_size         :integer
#  cover_updated_at        :datetime
#  environment             :text             default("production"), not null
#  featured                :boolean          default(FALSE)
#  icon_content_type       :string
#  icon_file_name          :string
#  icon_file_size          :integer
#  icon_updated_at         :datetime
#  logo_content_type       :string
#  logo_file_name          :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  name                    :string
#  partner_type            :string
#  published               :boolean          default(FALSE)
#  slug                    :string
#  summary                 :string
#  website                 :string
#  white_logo_content_type :string
#  white_logo_file_name    :string
#  white_logo_file_size    :integer
#  white_logo_updated_at   :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_partners_on_slug  (slug)
#

FactoryBot.define do
  factory :partner do
    name { FFaker::Name.name }
    summary { FFaker::Lorem.paragraph }
    contact_name { FFaker::Name.name }
    contact_email { FFaker::Internet.email }
    body { FFaker::HTMLIpsum.body }
    published { FFaker::Boolean.sample }
    featured { FFaker::Boolean.sample }
    website { FFaker::Internet.http_url }

    trait :production do
      environment { Environment::PRODUCTION }
    end

    factory :partner_production, traits: [:production]
  end
end
