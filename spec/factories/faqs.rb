FactoryBot.define do
  factory :faq do
    question { FFaker::LoremIE.question }
    answer { FFaker::LoremIE.paragraph }
    sequence(:order)

    trait :staging do
      environment { Environment::STAGING }
    end

    trait :production do
      environment { Environment::PRODUCTION }
    end

    trait :preproduction do
      environment { Environment::PREPRODUCTION }
    end

    factory :faq_staging, traits: [:staging]
    factory :faq_production, traits: [:production]
    factory :faq_preproduction, traits: [:preproduction]
  end
end
