# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    token_id 1
    content "MyText"
    agree_score 1
    oppose_score 1
    anonymous_flag false
    user nil
    edited_at "2014-12-24 16:59:18"
  end
end
