# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_1, class: Post do
    content "轻讨论1111"
    agree_score 15
    oppose_score 2
    actual_score 13
    anonymous_flag false
    association :user, factory: :user_1
  end

  factory :post_2, class: Post do
    content "轻讨论2222"
    agree_score 18
    oppose_score 2
    actual_score 16
    anonymous_flag false
    association :user, factory: :user_2
  end

  factory :post_3, class: Post do
    content "轻讨论3333"
    agree_score 11
    oppose_score 8
    actual_score 3
    anonymous_flag true
    association :user, factory: :user_3
  end

end
