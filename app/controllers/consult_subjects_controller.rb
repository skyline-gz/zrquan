require "date_utils.rb"

class ConsultSubjectsController < ApplicationController
  before_action :set_consult_subject, only: [:show, :edit, :update, :close, :accept, :ignore]
  before_action :authenticate_user!

  # 列表
  def index
    @consult_subjects = ConsultSubject.all
  end

  # 显示
  def show
  end

  # 新建咨询主题对象
  def new
		logger.debug("invoked consult_subjects new method.")
    @consult_subject = ConsultSubject.new
		@mentor = @consult_subject.build_mentor
		@mentor = User.find(params[:id])
  end

  # 编辑
  def edit
  end

  # 创建
  def create
		# 创建咨询主题
    @consult_subject = ConsultSubject.new(consult_subject_params)
		@consult_subject.apprentice_id = current_user.id
		@consult_subject.mentor_id = mentor_params[:mentor_attributes][:id]
		@consult_subject.stat_class = 1		# applying
		@consult_subject.save!
		# 创建消息并发送
		msg_content = "New consult apply " + @consult_subject.title + " to you."
		@consult_subject.mentor.messages.create!(content: msg_content, msg_type: 1)
		# 创建用户行为（申请咨询）
		current_user.activities.create!(target_id: @consult_subject.id, target_type: "ConsultSubject", activity_type: 8,
																		title: @consult_subject.title, publish_date: DateUtils.to_yyyymmdd(Date.today), 
																		theme:@consult_subject.theme, recent_flag: true)
		# TODO 发送到faye
		redirect_to @consult_subject, notice: 'Consult subject was successfully created.'
  end

  # 更新
  def update
    @consult_subject.update!(consult_subject_params)
    redirect_to @consult_subject, notice: 'Consult subject was successfully updated.'
  end

	# 接受咨询申请
	def accept
		# 更新状态并发送消息
		@consult_subject.update!(:stat_class=>2)
		msg_content = "Your consult apply " + @consult_subject.title + " has been accepted."
		@consult_subject.apprentice.messages.create!(content: msg_content, msg_type: 1)
		# 创建用户行为（接受申请）
		current_user.activities.create!(target_id: @consult_subject.id, target_type: "ConsultSubject", activity_type: 7,
																		title: @consult_subject.title, publish_date: DateUtils.to_yyyymmdd(Date.today), 
																		theme:@consult_subject.theme, recent_flag: true)
		redirect_to :back, notice: 'Consult subject was successfully updated.'
	end

	# 结束咨询
	def close
		# 更新状态
		logger.debug("invoked consult subject close")
		@consult_subject.update!(:stat_class=>3)
		# 创建消息并发送
		msg_content = "Consult " + @consult_subject.title + " has been closed."
		@consult_subject.apprentice.messages.create!(content: msg_content, msg_type: 1)
		@consult_subject.mentor.messages.create!(content: msg_content, msg_type: 1)
		redirect_to :back, notice: 'Consult subject was successfully updated.'
	end

	# 忽略咨询申请
	def ignore
		# 更新状态
		logger.debug("invoked consult subject ignore")
		@consult_subject.update!(:stat_class=>4)
		redirect_to :back, notice: 'Consult subject was successfully updated.'
	end

  # DELETE /consult_subjects/1
  # DELETE /consult_subjects/1.json
  #def destroy
  #  @consult_subject.destroy
  #  respond_to do |format|
  #    format.html { redirect_to consult_subjects_url, notice: 'Consult subject was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consult_subject
      @consult_subject = ConsultSubject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consult_subject_params
      params.require(:consult_subject).permit(:title, :content, :theme_id)
    end

		def mentor_params
      params.require(:consult_subject).permit(mentor_attributes:[:id])
    end		

end
