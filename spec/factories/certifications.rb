# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :certification do
    name "MyString"
    study_time_sum ""
    study_time_samples ""
    study_time_avg ""
    study_cost_sum ""
    study_cost_samples ""
    study_cost_avg ""
    regist_rule "MyText"
    description "MyText"
  end
end
