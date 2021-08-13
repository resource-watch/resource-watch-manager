FactoryBot.define do
  factory :faq do
    question { FFaker::LoremIE.question }
    answer { FFaker::LoremIE.paragraph }
    sequence(:order)

    trait :production do
      environment { Environment::PRODUCTION }
    end

    factory :faq_production, traits: [:production]
  end
end
