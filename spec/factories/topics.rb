# frozen_string_literal: true
FactoryBot.define do
  factory :topic_private_user_1, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '123abc' }
    private { true }
  end

  factory :topic_not_private_user_1, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '123abc' }
    private { false }
  end

  factory :topic_private_user_2, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '4a5b6c' }
    private { true }
  end

  factory :topic_not_private_user_2, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '4a5b6c' }
    private { false }
  end

  factory :topic_with_widgets, class: Topic do
    name { FFaker::Name.name }
    published { true }
    user_id { '4a5b6c' }
    private { false }
    content { "[{\"id\":1520242542490,\"type\":\"text\",\"content\":\"\\u003cp\\u003eBiodiversity intro\\u003c/p\\u003e\"},{\"id\":1518109294215,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109371974,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109389591,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109424849,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}}]" }
  end
end
