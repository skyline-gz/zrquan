require "date_utils.rb"
require 'returncode_define'

class AnswersController < ApplicationController
  before_action :set_answer, only: [:update, :agree]
  before_action :authenticate_user!

  # 创建
  def create
    @question = Question.find_by_token_id(params[:question_id])
    authorize! :answer, @question
    # 删除已创建草稿
    @answer_draft = AnswerDraft.find_by(:user_id => current_user.id, :question_id => @question.id)
    @answer_draft.destroy
    # 创建答案
    @answer = current_user.answers.new(answer_params)
    @answer.question_id = @question.id
    current_time = Time.now
    @answer.created_at = current_time
    @answer.edited_at = current_time
    @answer.updated_at = current_time
    @answer.save!
    @question.update!(hot_abs: @question.hot_abs + 3,
                      latest_answer_id: @answer.id,
                      latest_qa_time: DateUtils.to_yyyymmddhhmmss(current_time))
    # TODO 错误处理
    # 创建用户行为（回答问题）
    current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 2,
                                    publish_date: DateUtils.to_yyyymmdd(Date.today))
    # 创建消息并发送
    if current_user.user_msg_setting.answer_flag
      @question.user.messages.create!(msg_type: 1, extra_info1_id: current_user.id, extra_info1_type: "User",
                                        extra_info2_id: @question.id, extra_info2_type: "Question")
      # TODO 发送到faye
    end
    redirect_to :controller => 'questions',:action => 'show', :id => @question.token_id
  end

  # 更新
  def update
    @answer.edited_at = Time.now
    # 更新答案
    @answer.update!(answer_params)
    @question = Question.find(@answer.question_id)
    redirect_to :controller => 'questions',:action => 'show', :id => @question.token_id
  end

	# 赞同
  def agree
    if can? :agree, @answer
      # 更新赞同分数（因为职人的范围变广，所有人都+1）
      @answer.update!(agree_score: @answer.agree_score + 1)
      @question.update!(hot_abs: @question.hot_abs + 1)
      # 创建赞同答案的消息并发送
      MessagesAdapter.perform_async(MessagesAdapter::ACTION_TYPE[:USER_AGREE_ANSWER], current_user.id, @answer.id)
      current_user.agreements.create!(agreeable_id: @answer.id, agreeable_type: "Answer")
      # 创建用户行为（赞同答案）
      current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 5,
                                      publish_date: DateUtils.to_yyyymmdd(Date.today))
      render :json => { :code => ReturnCode::S_OK }
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  private
    def set_answer
      @question = Question.find_by_token_id(params[:question_id])
      @answer = Answer.find_by_token_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content)
    end		
end
