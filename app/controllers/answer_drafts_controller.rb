require 'returncode_define'

class AnswerDraftsController < ApplicationController
  before_action :set_question, only: [:save, :fetch]
  before_action :authenticate_user!

  # 存草稿
  def save
    if current_user.answered? @question
      render :json => { :code => ReturnCode::FA_QUESTION_ALREADY_ANSWERED } and return;
    end
    answer_draft = AnswerDraft.find_by(:user_id => current_user.id, :question_id => @question.id)
    unless answer_draft
      answer_draft = current_user.answer_drafts.new(:user_id => current_user.id, :question_id => @question.id)
    end
    answer_draft.content = params[:content]
    answer_draft.save
    render :json => { :code => ReturnCode::S_OK }
  end

  # 取一条草稿
  def fetch
    @answer_draft = AnswerDraft.find_by(:user_id => current_user.id, :question_id => @question.id)
    unless @answer_draft
      render :json => { :code => ReturnCode::FA_RESOURCE_NOT_EXIST } and return
    end
    render 'answer_drafts/show'
  end

  private
  def set_question
    @question = Question.find_by_token_id(params[:question_id])
  end
end