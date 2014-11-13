# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :school do
    name "MyString"
    city nil
    address "MyString"
    site "MyString"
    description "MyText"
  end
end
