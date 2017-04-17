# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :category do
    name FFaker::CheesyLingo.title
    description FFaker::HealthcareIpsum.paragraph(2)
  end
end
