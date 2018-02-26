# frozen_string_literal: true
FactoryGirl.define do
  factory :topic_private_user_1, class: Topic do
    name { FFaker::Name.name }
    published true
    user_id '123abc'
    private true
  end

  factory :topic_not_private_user_1, class: Topic do
    name { FFaker::Name.name }
    published true
    user_id '123abc'
    private false
  end

  factory :topic_private_user_2, class: Topic do
    name { FFaker::Name.name }
    published true
    user_id '4a5b6c'
    private true
  end

  factory :topic_not_private_user_2, class: Topic do
    name { FFaker::Name.name }
    published true
    user_id '4a5b6c'
    private false
  end
end
