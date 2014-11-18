# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    name "MyString"
    city nil
    industry nil
    parent_company nil
    address "MyString"
    site "MyString"
    contact "MyString"
    legal_person "MyString"
    capital_state 1
    description "MyText"
  end
end
