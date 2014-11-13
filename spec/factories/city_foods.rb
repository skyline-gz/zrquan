# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city_food do
    content "MyString"
    city nil
  end
end
