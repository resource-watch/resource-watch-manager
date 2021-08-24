# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text             not null
#  env        :text             default("production"), not null
#  order      :integer
#  question   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :faq do
    question { FFaker::LoremIE.question }
    answer { FFaker::LoremIE.paragraph }
    sequence(:order)

    trait :production do
      env { Environment::PRODUCTION }
    end

    factory :faq_production, traits: [:production]
  end
end
