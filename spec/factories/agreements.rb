# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer_agree, class: Agreement do
    association :agreeable, factory: :q1_other_answer_1
  end

  factory :article_agree, class: Agreement do
    #association :agreeable, factory: :q1_other_answer_1
  end
end
