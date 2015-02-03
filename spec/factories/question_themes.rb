# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nq_theme_1 do
    association :question, factory: :oldest_question
    association :theme, factory: :theme_industry_1
  end

  factory :nq_theme_2 do
    association :question, factory: :oldest_question
    association :theme, factory: :theme_region_1
  end

  factory :hq_theme_1 do
    association :question, factory: :hottest_question
    association :theme, factory: :theme_industry_1
  end

  factory :hq_theme_2 do
    association :question, factory: :hottest_question
    association :theme, factory: :theme_region_1
  end
end
