# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :personal_salary do
    user nil
    company nil
    position "MyString"
    salary ""
  end
end
