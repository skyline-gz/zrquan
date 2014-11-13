# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :corporate_group do
    name "MyString"
    industry nil
    site "MyString"
    legal_person "MyString"
    capital_state ""
    description "MyText"
  end
end
