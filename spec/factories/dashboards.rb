# frozen_string_literal: true
# == Schema Information
#
# Table name: dashboards
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  content            :text
#  published          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  summary            :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  user_id            :string
#  private            :boolean          default(TRUE)
#  production         :boolean          default(TRUE)
#  preproduction      :boolean          default(FALSE)
#  staging            :boolean          default(FALSE)
#  application        :string           default(["\"rw\""]), not null, is an Array
#  is_highlighted     :boolean          default(FALSE)
#  is_featured        :boolean          default(FALSE)
#

FactoryBot.define do
  factory :dashboard_private_manager, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '1a10d7c6e0a37126611fd7a6' }
    application { ['rw'] }
    is_highlighted { false }
    is_featured { true }
    private { true }
  end

  factory :dashboard_private_user_1, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '57a1ff091ebc1ad91d089bdc' }
    application { ['rw'] }
    is_highlighted { true }
    is_featured { true }
    private { true }
  end

  factory :dashboard_private_user_2, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c143429f8d19932db9d06ea' }
    application { ['rw'] }
    is_highlighted { false }
    is_featured { false }
    private { true }
  end

  factory :dashboard_not_private_user_1, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '57a1ff091ebc1ad91d089bdc' }
    application { %w(rw gfw) }
    is_highlighted { false }
    is_featured { false }
    private { false }
  end

  factory :dashboard_not_private_user_2, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c143429f8d19932db9d06ea' }
    application { ['gfw'] }
    is_highlighted { false }
    is_featured { false }
    private { false }
  end

  factory :dashboard_not_private_user_3, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c069855ccc46a6660a4be68' }
    application { ['gfw'] }
    is_highlighted { false }
    is_featured { false }
    private { false }
  end

  factory :dashboard_with_widgets, class: Dashboard do
    name { FFaker::Name.name }
    published { true }
    user_id { '5c143429f8d19932db9d06ea' }
    private { false }
    is_highlighted { false }
    is_featured { false }
    content { "[{\"id\":1520242542490,\"type\":\"text\",\"content\":\"\\u003cp\\u003eBiodiversity intro\\u003c/p\\u003e\"},{\"id\":1518109294215,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109371974,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109389591,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}},{\"id\":1518109424849,\"type\":\"widget\",\"content\":{\"widgetId\":\"841a6544-e8c9-411d-9987-83e81b58fd6f\",\"datasetId\":\"9aa17362-2a4f-4a4f-9e4e-97ebb60ce76b\",\"categories\":[]}}]" }
  end
end
