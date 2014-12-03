require "date_utils.rb"

class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy, :agree]

  # 列表
  def index
    @answers = Answer.all
  end

  # 显示
  def show
  end

  # 新建答案对象
  def new
    @answer = Answer.new
  end

  # 编辑
  def edit
    authorize! :edit, @answer
  end

  # 创建
  def create
    @question = Question.find(params[:question_id])
    authorize! :answer, @question
    # 创建答案
    @answer = current_user.answers.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.save!
    # TODO 错误处理
    # 创建用户行为（回答问题）
    current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 2,
                                    publish_date: DateUtils.to_yyyymmdd(Date.today))
    # 创建消息并发送
    if current_user.user_msg_setting.answer_flag == true
      @question.user.messages.create!(msg_type: 1, extra_info1_id: current_user.id, extra_info1_type: "User",
                                        extra_info2_id: @question.id, extra_info2_type: "Question")
      # TODO 发送到faye
    end
    redirect_to question_path(@question), notice: 'Answer was successfully created.'
  end

  # 更新
  def update
    @question = Question.find(@answer.question_id)
    # 更新答案
    @answer.update!(answer_params)
    redirect_to question_path(@question)
  end

	# 赞同
  def agree
    authorize! :agree, @answer
    @question = Question.find(@answer.question_id)
    latest_score = @answer.agree_score
    logger.debug(latest_score)
    # 更新赞同分数（因为职人的范围变广，所有人都+1）
    latest_score = latest_score + 1
    @answer.update!(:agree_score => latest_score)
    # 创建消息，发送给用户
    if @answer.user.user_msg_setting.agreed_flag
      logger.debug("message")
      @answer.user.messages.create!(msg_type: 12, extra_info1_id: current_user.id, extra_info1_type: "User",
                                       extra_info2_id: @question.id, extra_info2_type: "Question")
    end
    # 创建用户赞同信息
    current_user.agreements.create!(agreeable_id: @answer.id, agreeable_type: "Answer")
    # 创建用户行为（赞同答案）
    current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 5,
                                    publish_date: DateUtils.to_yyyymmdd(Date.today))
    redirect_to question_path(@question), notice: 'Answer was successfully updated.'
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  #def destroy
  #  @answer.destroy
  #  respond_to do |format|
  #    format.html { redirect_to answers_url, notice: 'Answer was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content)
    end		
end
