# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                 :bigint           not null, primary key
#  application        :string           default(["\"rw\""]), not null, is an Array
#  content            :text
#  description        :string
#  name               :string
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :bigint
#  photo_updated_at   :datetime
#  private            :boolean          default(TRUE)
#  published          :boolean
#  slug               :string
#  summary            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :string
#

FactoryBot.define do
  factory :topic_private_manager, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '1a10d7c6e0a37126611fd7a6' }
    application { ['rw'] }
    private { true }
  end

  factory :topic_private_user_1, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '57a1ff091ebc1ad91d089bdc' }
    application { ['rw'] }
    private { true }
  end

  factory :topic_not_private_user_1, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '57a1ff091ebc1ad91d089bdc' }
    application { ['rw'] }
    private { false }
  end

  factory :topic_private_user_2, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c143429f8d19932db9d06ea' }
    application { %w(rw gfw) }
    private { true }
  end

  factory :topic_not_private_user_2, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c069855ccc46a6660a4be68' }
    application { ['gfw'] }
    private { false }
  end

  factory :topic_with_widgets, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c143429f8d19932db9d06ea' }
    application { ['gfw'] }
    private { false }
    content { "[{\"id\":1520242542490,\"type\":\"text\",\"content\":\"\\u003cp\\u003eBiodiversity intro\\u003c/p\\u003e\"},{\"id\":1518109294215,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109371974,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109389591,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109424849,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}}]" }
  end
end
