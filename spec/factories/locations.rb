# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "MyString"
    region nil
    expense "MyText"
    strong_industry "MyText"
    entry_policy "MyText"
    support_policy "MyText"
    description "MyText"
  end
end
