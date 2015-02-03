# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bookmark do
    association :user, factory: :user_1

    factory :bookmark_q1 do
      association :bookmarkable, factory: :oldest_question
      created_at      Time.new(2015,1,1)
    end

    factory :bookmark_q2 do
      association :bookmarkable, factory: :hottest_question
      created_at      Time.new(2015,1,14)
    end

    factory :bookmark_q3 do
      association :bookmarkable, factory: :anonymous_question
      created_at      Time.new(2015,1,11)
    end

    factory :bookmark_p1 do
      association :bookmarkable, factory: :post_1
      created_at      Time.new(2015,1,8)
    end

    factory :bookmark_p2 do
      association :bookmarkable, factory: :post_4
      created_at      Time.new(2015,1,11)
    end

    factory :bookmark_p3 do
      association :bookmarkable, factory: :post_5
      created_at      Time.new(2015,1,18)
    end

  end
end
