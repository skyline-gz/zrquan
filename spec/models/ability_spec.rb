require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, :type => :model do
  subject { ability }

  context "unconfirmed user" do
    let (:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }
    let (:ability) { Ability.new(unconfirmed_user) }

    it { should_not be_able_to(:create, Question) }
    it { should_not be_able_to(:create, Answer) }
    it { should_not be_able_to(:create, Comment) }
    it { should_not be_able_to(:create, PrivateMessage) }
    it { should_not be_able_to(:create, ConsultSubject) }
    it { should_not be_able_to(:create, ConsultReply) }
    it { should_not be_able_to(:create, Relationship) }
  end

  context "mentor" do
    let (:mentor) { FactoryGirl.create(:mentor_1) }
    let (:normal_user) { FactoryGirl.create(:normal_user_1) }
    let (:question) { FactoryGirl.create(:question_1) }

    let (:ability) { Ability.new(mentor) }

    it { should_not be_able_to(:create, Question) }
    it { should_not be_able_to(:create, ConsultSubject) }
    it { should_not be_able_to(:edit, Question) }
    it { should_not be_able_to(:edit, ConsultSubject) }
    it { should be_able_to(:answer, question) }
    it {
      FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor)
      should_not be_able_to(:answer, question)
    }
    it { should be_able_to(:edit, mentor) }
    it { should_not be_able_to(:edit, normal_user) }

  end

  context "normal_user" do

  end
end
