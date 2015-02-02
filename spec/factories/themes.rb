# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :theme_com_1 do
    name         "子公司"
    association   :substance, factory: :child_company
  end

  factory :theme_industry_1 do
    name            "行业主题1"
    association   :substance, factory: :internet
  end

  factory :theme_region_1 do
    name            "canton"
    association   :substance, factory: :canton
  end
end
