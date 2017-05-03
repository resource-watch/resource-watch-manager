# == Schema Information
#
# Table name: apps
#
#  id                     :integer          not null, primary key
#  name                   :string
#  description            :text
#  body                   :text
#  technical_details      :text
#  author                 :string
#  web_url                :string
#  ios_url                :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryGirl.define do
  factory :app do
    sequence(:name) { |n| "#{n} #{FFaker::CheesyLingo.title}" }
    description FFaker::HealthcareIpsum.paragraph
    body FFaker::HTMLIpsum.body
    technical_details FFaker::HealthcareIpsum.paragraph
    author FFaker::CheesyLingo.name
    web_url FFaker::InternetSE.http_url
    ios_url FFaker::InternetSE.http_url
  end
end