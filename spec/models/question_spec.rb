require 'rails_helper'

RSpec.describe Question, :type => :model do
	context "with more than 2 answers" do
    let (:question) {FactoryGirl.create(:question_1)}
    let (:mentor_1) {FactoryGirl.create(:mentor_1)}
    let (:mentor_2) {FactoryGirl.create(:mentor_2)}
    let (:invitation_1) {FactoryGirl.create(:q1_invitation_1, :question=>question, :user=>mentor_1)}
    let (:invitation_2) {FactoryGirl.create(:q1_invitation_2, :question=>question, :user=>mentor_2)}

    it "invited mentors' answers should before other users' answers " do
      invitation_1
      other_answer_1 = FactoryGirl.create(:q1_other_answer_1, :question=>question)
      invited_answer_1 = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor_1)
      sorted_answers = question.sorted_answers
      expect(sorted_answers[0]).to eq(invited_answer_1)
      expect(sorted_answers[1]).to eq(other_answer_1)
    end

    it "multiple invited mentors' answers should sorted by agree scores desc " do
      invitation_1
      invitation_2
      answer_score_20 = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor_1)
      answer_score_25 = FactoryGirl.create(:q1_invited_answer_2, :question=>question, :user=>mentor_2)
      sorted_answers = question.sorted_answers
      expect(sorted_answers[0]).to eq(answer_score_25)
      expect(sorted_answers[1]).to eq(answer_score_20)
    end

    it "multiple other users' answers should sorted by agree scores desc" do
      answer_score_30 = FactoryGirl.create(:q1_other_answer_1, :question=>question)
      answer_score_40 = FactoryGirl.create(:q1_other_answer_2, :question=>question)
      sorted_answers = question.sorted_answers
      expect(sorted_answers[0]).to eq(answer_score_40)
      expect(sorted_answers[1]).to eq(answer_score_30)
    end

    it "should sort answers according to the rules above when there multiple invited answers and normal answers" do
      invitation_1
      invitation_2
      invited_answer_score_20 = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor_1)
      invited_answer_score_25 = FactoryGirl.create(:q1_invited_answer_2, :question=>question, :user=>mentor_2)
      other_answer_score_30 = FactoryGirl.create(:q1_other_answer_1, :question=>question)
      other_answer_score_40 = FactoryGirl.create(:q1_other_answer_2, :question=>question)
      sorted_answers = question.sorted_answers
      expect(sorted_answers[0]).to eq(invited_answer_score_25)
      expect(sorted_answers[1]).to eq(invited_answer_score_20)
      expect(sorted_answers[2]).to eq(other_answer_score_40)
      expect(sorted_answers[3]).to eq(other_answer_score_30)
    end
  end
end
