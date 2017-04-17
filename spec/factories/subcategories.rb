# == Schema Information
#
# Table name: subcategories
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#

FactoryGirl.define do
  factory :subcategory do
    name FFaker::CheesyLingo.title
    description FFaker::HealthcareIpsum.paragraph(2)
  end
end
