# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :it do
    name "IT"
  end

  factory :internet do
    name         "互联网"
    association  :parent_industry, factory: :it
  end
end
