# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :parent_company do
    name  "母公司"
  end

  factory :child_company do
    name  "子公司"
    association   :location, factory: :gz
    association   :industry, factory: :internet
    association   :parent_company, factory: :parent_company
  end

end
