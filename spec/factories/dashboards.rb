# frozen_string_literal: true
# == Schema Information
#
# Table name: dashboards
#
#  id                        :bigint           not null, primary key
#  application               :string           default(["\"rw\""]), not null, is an Array
#  author_image_content_type :string
#  author_image_file_name    :string
#  author_image_file_size    :integer
#  author_image_updated_at   :datetime
#  author_title              :string           default("")
#  content                   :text
#  description               :string
#  env                       :text             default("production"), not null
#  is_featured               :boolean          default(FALSE)
#  is_highlighted            :boolean          default(FALSE)
#  name                      :string
#  photo_content_type        :string
#  photo_file_name           :string
#  photo_file_size           :integer
#  photo_updated_at          :datetime
#  private                   :boolean          default(TRUE)
#  published                 :boolean
#  slug                      :string
#  summary                   :string
#  user_name                 :string
#  user_role                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :string
#

FactoryBot.define do
  factory :dashboard do
    name { FFaker::Name.name }
    published { true }
    author_title { FFaker::Name.name }
    is_highlighted { false }
    is_featured { false }
    env { Environment::PRODUCTION }

    trait :private do
      private { true }
    end

    trait :not_private do
      private { false }
    end

    trait :manager do
      user_id { '1a10d7c6e0a37126611fd7a6' }
    end

    trait :user1 do
      user_id { '57a1ff091ebc1ad91d089bdc' }
    end

    trait :user2 do
      user_id { '5c143429f8d19932db9d06ea' }
    end

    trait :user3 do
      user_id { '5c069855ccc46a6660a4be68' }
    end

    trait :production do
      env { Environment::PRODUCTION }
    end

    trait :rw do
      application { ['rw'] }
    end

    trait :gfw do
      application { ['gfw'] }
    end

    trait :rw_gfw do
      application { %w(rw gfw) }
    end

    trait :highlighted do
      is_highlighted { true }
    end

    trait :featured do
      is_featured { true }
    end

    factory :dashboard_private_manager, traits: [:private, :manager, :rw, :featured]
    factory :dashboard_private_user_1, traits: [:private, :user1, :rw, :highlighted, :featured]
    factory :dashboard_private_user_2, traits: [:private, :user2, :rw]
    factory :dashboard_not_private_user_1, traits: [:not_private, :user1, :rw_gfw]
    factory :dashboard_not_private_user_2, traits: [:not_private, :user2, :gfw]
    factory :dashboard_not_private_user_3, traits: [:not_private, :user3, :gfw]
    factory :dashboard_with_widgets, traits: [:not_private, :user2, :highlighted, :featured] do
      content { "[{\"id\":1520242542490,\"type\":\"text\",\"content\":\"\\u003cp\\u003eBiodiversity intro\\u003c/p\\u003e\"},{\"id\":1518109294215,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109371974,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109389591,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109424849,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}}]" }
    end
    factory :dashboard_without_widgets, traits: [:not_private, :user2] do
      content { nil }
    end
    factory :dashboard_production, traits: [:production]
  end
end
