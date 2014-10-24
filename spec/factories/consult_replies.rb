# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consult_reply do
    content     "咨询回复"
    association :consult_subject, factory: :in_progress_subject
    association :user, factory: :normal_user_1
  end

end
