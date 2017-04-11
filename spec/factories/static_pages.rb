# frozen_string_literal: true
# frozen_string_literal: true
# == Schema Information
#
# Table name: static_pages
#
#  id                 :integer          not null, primary key
#  title              :string           not null
#  summary            :text
#  description        :text
#  content            :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published          :boolean
#

# Table name: static_pages
#
#  id                 :integer          not null, primary key
#  title              :string           not null
#  summary            :text
#  description        :text
#  content            :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# frozen_string_literal: true

FactoryGirl.define do
  factory :static_page do
    title FFaker::CheesyLingo.title
    summary FFaker::HealthcareIpsum.paragraph
    description FFaker::HealthcareIpsum.paragraph(2)
    content FFaker::HTMLIpsum.body
  end
end
