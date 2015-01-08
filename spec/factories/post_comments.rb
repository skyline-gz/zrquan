# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_comment do
    content "MyText"
    agree_score 1
    oppose_score 1
    anonymous_flag false
    user nil
    replied_comment nil
  end
end
