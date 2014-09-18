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
  end

  # 创建
  def create
		# 创建答案
    @answer = current_user.answers.new(answer_params)
		@answer.question_id = params[:question_id]
		@answer.save!
		# 更新问题的答案数
		@question = Question.find(@answer.question_id)
		@question.update_attributes!(answer_num: @question.answer_num + 1)
		# 创建用户行为（回答问题）
		current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 2,
																		title: @question.title, content: @answer.content, publish_date: today_to_i, 
																		theme:@question.theme, recent_flag: true)
		# 创建消息并发送
		if current_user.user_setting.answer_flag == true
			msg_content = "New answer for your question: " + @question.title + "."
			@question.user.messages.create!(content: msg_content, msg_type: 1)
			# TODO 发送到faye
		end
	  redirect_to question_path(@question), notice: 'Answer was successfully created.'
  end

  # 更新
  def update
		@question = Question.find(@answer.question_id)
		# 更新答案
		@answer.update_attributes!(answer_params)
		# 创建对应消息，发送给用户
		if current_user.user_setting.answer_flag == true
			msg_content = "Answer for your question: " + @question.title + " has been updated."
			@question.user.messages.create!(content: msg_content, msg_type: 1)
			# TODO 发送到faye
		end
	  redirect_to question_path(@question), notice: 'Answer was successfully updated.'
  end

	# 赞同
	def agree
		@question = Question.find(@answer.question_id)
		latest_score = @answer.agree_score
		logger.debug(latest_score)
		# 更新赞同分数（导师+2，普通用户+1）
		if current_user.mentor_flag
			latest_score = latest_score + 2
			@answer.update_attributes!(:agree_score => latest_score)
		else
			latest_score = latest_score + 1
			@answer.update_attributes!(:agree_score => latest_score)
		end
		# 创建消息，发送给用户
		if @answer.user.user_setting.aggred_flag
			logger.debug("message")
			msg_content = current_user.email + " agreed your answer for " + @question.title + "."
			@answer.user.messages.create!(content: msg_content, msg_type: 1)
		end
		# 创建用户赞同信息
		current_user.agreements.create!(agreeable_id: @answer.id, agreeable_type: "Answer")
		# 创建用户行为（赞同答案）
		current_user.activities.create!(target_id: @answer.id, target_type: "Answer", activity_type: 5,
																		title: @question.title, content: @answer.content, publish_date: today_to_i, 
																		theme:@question.theme, recent_flag: true)
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
      params.require(:answer).permit(:content, :agree_score, :user_id, :question_id)
    end

		# 转换当前日期为int类型
		def today_to_i
			Date.today.to_s.gsub("-", "").to_i
		end
end
