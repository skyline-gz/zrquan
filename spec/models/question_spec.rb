require 'rails_helper'

RSpec.describe Question, :type => :model do
	context "with more than 2 answers" do
    let (:question) {FactoryGirl.create(:question_1)}
    let (:v_user_1) {FactoryGirl.create(:v_user_1)}
    let (:v_user_2) {FactoryGirl.create(:v_user_2)}

    it "multiple other users' answers should sorted by agree scores desc" do
      answer_score_30 = FactoryGirl.create(:q1_other_answer_1, :question=>question)
      answer_score_40 = FactoryGirl.create(:q1_other_answer_2, :question=>question)
      sorted_answers = question.sorted_answers
      expect(sorted_answers[0]).to eq(answer_score_40)
      expect(sorted_answers[1]).to eq(answer_score_30)
    end

    # it "invited mentors' answers should before other users' answers " do
    # end

    # it "multiple invited mentors' answers should sorted by agree scores desc " do
    # end

    # it "should sort answers according to the rules above when there multiple invited answers and normal answers" do
    # end
  end
end
