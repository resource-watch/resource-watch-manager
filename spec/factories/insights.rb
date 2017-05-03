# == Schema Information
#
# Table name: insights
#
#  id                 :integer          not null, primary key
#  title              :string
#  summary            :text
#  description        :text
#  content            :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  published          :boolean
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :insight do
    sequence(:title) {|n| "#{n} #{FFaker::CheesyLingo.title}"}
    summary FFaker::HealthcareIpsum.paragraph
    description FFaker::HealthcareIpsum.paragraph(2)
    content FFaker::HTMLIpsum.body
    published true
  end
end



