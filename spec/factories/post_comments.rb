# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_comment_1, class: PostComment  do
    content "评论呀呀呀呀"
    agree_score 50
    oppose_score 1
    actual_score 49
    anonymous_flag false
    association :post, factory: :post_1
    association :user, factory: :user_1
    created_at      Time.new(2015,1,1)
  end

  factory :post_comment_2, class: PostComment  do
    content "评论呀呀呀呀"
    agree_score 25
    oppose_score 2
    actual_score 23
    anonymous_flag true
    association :post, factory: :post_1
    association :user, factory: :user_2
    created_at      Time.new(2015,1,6)
  end

  factory :post_comment_3, class: PostComment  do
    content "评论呀呀呀呀"
    agree_score 100
    oppose_score 20
    actual_score 80
    anonymous_flag true
    association :post, factory: :post_1
    association :user, factory: :user_3
    created_at      Time.new(2015,1,8)
  end

end
