class ConsultRepliesController < ApplicationController
  before_action :set_consult_reply, only: [:show, :edit, :update, :destroy]

  # 列表
  def index
    @consult_replies = ConsultReply.all
  end

  # 显示
  def show
  end

  # 新建咨询回复对象
  def new
    @consult_reply = ConsultReply.new
  end

  # 编辑
  def edit
  end

  # 创建
  def create
		# 创建咨询回复
		@consult_reply = current_user.consult_replies.build(consult_reply_params)
		@consult_reply.consult_subject_id = params[:consult_subject_id]
		@consult_reply.save!
		# 创建消息并发送
		@consult_subject = ConsultSubject.find(params[:consult_subject_id])
		if current_user.id == @consult_subject.mentor_id
			user_id = @consult_subject.apprentice_id
		else
			user_id = @consult_subject.mentor_id				
		end
		msg_content = "New consult reply for " + @consult_subject.title + "."
		Message.create!(content: msg_content, msg_type: 1, user_id: user_id)
	  redirect_to consult_subject_path(@consult_subject), notice: 'Consult reply was successfully created.'
  end

  # 更新
  def update
		@consult_reply.update!(consult_reply_params)
    redirect_to @consult_reply, notice: 'Consult reply was successfully updated.'
  end

  # DELETE /consult_replies/1
  # DELETE /consult_replies/1.json
  #def destroy
  #  @consult_reply.destroy
  #  respond_to do |format|
  #    format.html { redirect_to consult_replies_url, notice: 'Consult reply was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consult_reply
      @consult_reply = ConsultReply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consult_reply_params
      params.require(:consult_reply).permit(:content)
    end
end
