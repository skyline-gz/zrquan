FactoryGirl.define do
  factory :q1_invitation_1, class: Invitation do
		association :question, factory: :question_1
    association :user, factory: :mentor_1
  end

  factory :q1_invitation_2, class: Invitation do
    association :question, factory: :question_1
    association :user, factory: :mentor_2
  end

end
