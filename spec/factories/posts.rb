# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_1, class: Post do
    content         "轻讨论1111"
    agree_score     15
    oppose_score    2
    actual_score    13
    anonymous_flag  false
    created_at      Time.new(2015,1,13)
    association :user, factory: :user_1
  end

  factory :post_2, class: Post do
    content "轻讨论2222"
    agree_score 18
    oppose_score 2
    actual_score 16
    anonymous_flag false
    created_at      Time.new(2015,1,15)
    association :user, factory: :user_2
  end

  factory :post_3, class: Post do
    content "轻讨论3333"
    agree_score 11
    oppose_score 8
    actual_score 3
    anonymous_flag true
    created_at      Time.new(2015,1,16)
    association :user, factory: :user_3
  end

  factory :post_4, class: Post do
    content "轻讨论44"
    agree_score 18
    oppose_score 8
    actual_score 10
    anonymous_flag true
    created_at      Time.new(2015,1,17)
    association :user, factory: :user_1
  end

  factory :post_5, class: Post do
    content "轻讨论55"
    agree_score 12
    oppose_score 5
    actual_score 7
    anonymous_flag false
    created_at      Time.new(2015,2,1)
    association :user, factory: :user_1
  end

end
