# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gz do
    name "广州"
    association   :region, factory: :canton
  end
end
