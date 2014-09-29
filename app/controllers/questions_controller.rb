class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # 列表
  def index
    @questions = Question.all
  end

  # 显示
  def show
		#@user = User.find(params[:id])
		#@questions = @user.questions
  end

  # 新建问题对象
  def new
    @question = Question.new
		@question.invitations.build
  end

  # 编辑
  def edit
  end

  # 创建
  def create
		# 创建问题和邀请
		ActiveRecord::Base.transaction do
	  	@question = current_user.questions.new(question_params)
			@question.save!
			logger.debug(invitations_params)
			if invitations_params != {}
				invitations_params[:invitations_attributes][:mentor_id].each do |m_id|
					@invitation = Invitation.new
					@invitation.question_id = @question.id
					@invitation.mentor_id = m_id
					@invitation.save!
					# 发信息给受邀导师
					msg_content = "You are invited to answer " + @question.title + "."
					@invitation.mentor.messages.create!(content: msg_content, msg_type: 1)
				end
			end
		end
		# 创建用户行为（发布问题）
		current_user.activities.create!(target_id: @question.id, target_type: "Question", activity_type: 1,
																		title: @question.title, publish_date: today_to_i, 
																		theme:@question.theme, recent_flag: true)
		redirect_to @question, notice: 'Question was successfully created.'
  end

  # 更新
  def update
		# 更新问题和邀请
		ActiveRecord::Base.transaction do
			@question.update!(question_params)
			if !Invitation.destroy_all(question_id:@question.id)
				raise ActiveRecord::Rollback
			end
			invitations_params[:invitations_attributes][:mentor_id].each do |m_id|
				@invitation = Invitation.new
				@invitation.question_id = @question.id
				@invitation.mentor_id = m_id
				@invitation.save!
				# 发信息给受邀导师
				msg_content = "You are invited to answer " + @question.title + "."
				@invitation.mentor.messages.create!(content: msg_content, msg_type: 1)
			end
		end
		redirect_to @question, notice: 'Question was successfully updated.'
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  #def destroy
  #  @question.destroy
  #  respond_to do |format|
  #    format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :content, :theme_id)
    end

		def invitations_params
      params.require(:question).permit(invitations_attributes:[:mentor_id=>[]])
    end

		# 转换当前日期为int类型
		def today_to_i
			Date.today.to_s.gsub("-", "").to_i
		end
end
