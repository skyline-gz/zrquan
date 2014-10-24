# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bookmark do
    association :user, factory: :normal_user_1

    factory :question_bookmark do
      association :bookmarkable, factory: :question_1
    end

    factory :article_bookmark do
      association :bookmarkable, factory: :published_article
    end
  end
end
