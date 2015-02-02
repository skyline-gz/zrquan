# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    token_id 1
    content "轻讨论1adfsfdfdfdf"
    agree_score 1
    oppose_score 1
    anonymous_flag false
    user nil
  end
end
