# frozen_string_literal: true

# == Schema Information
#
# Table name: partners
#
#  id                      :integer          not null, primary key
#  name                    :string
#  slug                    :string
#  summary                 :string
#  contact_name            :string
#  contact_email           :string
#  body                    :text
#  logo_file_name          :string
#  logo_content_type       :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  white_logo_file_name    :string
#  white_logo_content_type :string
#  white_logo_file_size    :integer
#  white_logo_updated_at   :datetime
#  icon_file_name          :string
#  icon_content_type       :string
#  icon_file_size          :integer
#  icon_updated_at         :datetime
#  published               :boolean
#  featured                :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cover_file_name         :string
#  cover_content_type      :string
#  cover_file_size         :integer
#  cover_updated_at        :datetime
#  website                 :string
#

FactoryGirl.define do
  factory :partner do
    name FFaker::Name.name
    summary FFaker::Lorem.paragraph
    contact_name FFaker::Name.name
    contact_email FFaker::Internet.email
    body FFaker::HTMLIpsum.body
    published true
    featured true
    website FFaker::Internet.http_url
  end
end
