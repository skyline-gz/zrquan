# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :industry do
    name "MyString"
    description "MyText"
    parent_industry nil
  end
end
