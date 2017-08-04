# == Schema Information
#
# Table name: dashboards
#
#  id          :integer          not null, primary key
#  name        :string
#  slug        :string
#  description :string
#  content     :text
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  summary     :string
#  photo       :string
#

FactoryGirl.define do
  factory :dashboard do
    name "MyString"
    slug "MyString"
    description "MyString"
    body "MyText"
    published false
  end
end
