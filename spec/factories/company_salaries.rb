# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company_salary do
    company nil
    position "MyString"
    salary_sum ""
    samples ""
    salary_avg ""
  end
end
