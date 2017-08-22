FactoryGirl.define do
  factory :dashboard_private_user_1, class: Dashboard do
    name {FFaker::Name.name}
    published true
    user_id "123abc"
    private true
  end

  factory :dashboard_not_private_user_1, class: Dashboard do
    name {FFaker::Name.name}
    published true
    user_id "123abc"
    private false
  end

  factory :dashboard_private_user_2, class: Dashboard do
    name {FFaker::Name.name}
    published true
    user_id "4a5b6c"
    private true
  end

  factory :dashboard_not_private_user_2, class: Dashboard do
    name {FFaker::Name.name}
    published true
    user_id "4a5b6c"
    private false
  end
end