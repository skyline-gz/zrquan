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
    it { should_not be_able_to(:create, Relationship) }
  end

  context "verified user" do
    let (:normal_user) { FactoryGirl.create(:normal_user_1) }
    let (:me) { FactoryGirl.create(:v_user_1) }
    let (:question) { FactoryGirl.create(:real_name_question, :user=>normal_user) }
    let (:my_question) { FactoryGirl.create(:real_name_question, :user=>me) }
    let (:my_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>me) }
    let (:another_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>normal_user) }
    let (:ability) { Ability.new(me) }

    context "question" do
      it { should be_able_to(:create, Question) }
      it { should be_able_to(:edit, my_question) }
    end

    context "answer" do
      it { should be_able_to(:answer, question) }
      it {
        my_answer = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>me)
        should be_able_to(:edit, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        should_not be_able_to(:edit, other_answer)
      }
      it {
        FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:answer, answered_question = question)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        should be_able_to(:agree, other_answer)
      }
      it {
        my_answer = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:agree, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        FactoryGirl.create(:answer_agree, :user=>me, :agreeable=>other_answer)
        should_not be_able_to(:agree, agreed_answer = other_answer)
      }
    end

    context "comment" do
      it { should be_able_to(:comment, Answer) }
    end

    context "bookmark" do
      it { should be_able_to(:bookmark, question) }
      it {
        FactoryGirl.create(:question_bookmark, :user=>me, :bookmarkable=>question)
        should_not be_able_to(:bookmark, question)
      }
    end

    context "follow" do
      it { should be_able_to(:follow, other_user = normal_user) }
      it { should_not be_able_to(:follow, myself = me) }
      it {
        FactoryGirl.create(:relationship, :following_user=>normal_user, :follower=>me)
        should be_able_to(:unfollow, following_user = normal_user)
      }
      it { should_not be_able_to(:unfollow, not_following = normal_user) }
    end

    context "pm" do
      it {
        FactoryGirl.create(:relationship, :following_user=>me, :follower=>normal_user)
        should be_able_to(:pm, follower = normal_user)
      }
      it {
        FactoryGirl.create(:private_message, :user1=>normal_user, :user2=>me)
        should be_able_to(:pm, ever_pm_user = normal_user)
      }
      it { should_not be_able_to(:pm, no_relationship_user = normal_user) }
    end

    context "user info and user setting" do
      it { should be_able_to(:edit, me) }
      it { should_not be_able_to(:edit, normal_user) }
      it { should be_able_to(:edit, my_user_msg_setting) }
      it { should_not be_able_to(:edit, another_user_msg_setting) }
    end

  end

  context "normal_user" do
    let (:me) { FactoryGirl.create(:normal_user_2) }
    let (:verified_user) { FactoryGirl.create(:v_user_1) }
    let (:another_n_user) { FactoryGirl.create(:normal_user_1) }
    let (:question) { FactoryGirl.create(:real_name_question, :user=>another_n_user) }
    let (:my_question) { FactoryGirl.create(:real_name_question, :user=>me) }
    let (:my_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>me) }
    let (:another_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>another_n_user) }
    let (:ability) { Ability.new(me) }

    context "question" do
      it { should be_able_to(:create, Question) }
      it { should be_able_to(:edit, my_question) }
    end

    context "answer" do
      it { should_not be_able_to(:answer, my_question) }
      it { should be_able_to(:answer, not_my_question = question) }
      it {
        my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>me)
        should be_able_to(:edit, my_answer)
      }
      it {
        not_my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>another_n_user)
        should_not be_able_to(:edit, not_my_answer)
      }
      it {
        FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:answer, answered_question = question)
      }
      it {
        not_my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>another_n_user)
        should be_able_to(:agree, not_my_answer)
      }
      it {
        my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:agree, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>another_n_user)
        FactoryGirl.create(:answer_agree, :user=>me, :agreeable=>other_answer)
        should_not be_able_to(:agree, agreed_answer = other_answer)
      }
    end

    context "comment" do
      it { should be_able_to(:comment, Answer) }
    end

    context "bookmark" do
      it { should be_able_to(:bookmark, question) }
      it {
        FactoryGirl.create(:question_bookmark, :user=>me, :bookmarkable=>question)
        should_not be_able_to(:bookmark, bookmarked_question = question)
      }
    end

    context "follow" do
      it { should be_able_to(:follow, other_user = verified_user) }
      it { should_not be_able_to(:follow, myself = me) }
      it {
        FactoryGirl.create(:relationship, :following_user=>verified_user, :follower=>me)
        should be_able_to(:unfollow, following_user = verified_user)
      }
      it { should_not be_able_to(:unfollow, not_following = verified_user) }
    end

    context "pm" do
      it {
        FactoryGirl.create(:relationship, :following_user=>me, :follower=>verified_user)
        should be_able_to(:pm, follower = verified_user)
      }
      it {
        FactoryGirl.create(:private_message, :user1=>me, :user2=>verified_user)
        should be_able_to(:pm, ever_pm_user = verified_user)
      }
      it { should_not be_able_to(:pm, no_relationship_user = verified_user) }
    end

    context "user info and user setting" do
      it { should be_able_to(:edit, me) }
      it { should_not be_able_to(:edit, other_user = verified_user) }
      it { should be_able_to(:edit, my_user_msg_setting) }
      it { should_not be_able_to(:edit, another_user_msg_setting) }
    end

  end
end
