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
    replied_comment nil
  end
end
