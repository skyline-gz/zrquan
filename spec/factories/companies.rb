# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    name "MyString"
    city nil
    industry nil
    corporate_group nil
    address "MyString"
    site "MyString"
    contact "MyString"
    legal_person "MyString"
    capital_state ""
    description "MyText"
  end
end
