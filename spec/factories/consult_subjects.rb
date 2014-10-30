# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consult_subject do
    title       "咨询主题题目字数补完"
    content     "咨询主题内容"
    association :apprentice, factory: :normal_user_1
    association :mentor, factory: :mentor_1

    factory :applying_subject do
      stat_class  1
    end

    factory :in_progress_subject do
      stat_class  2
    end

    factory :closed_subject do
      stat_class  3
    end

    factory :ignored_subject do
      stat_class  4
    end
  end
end
