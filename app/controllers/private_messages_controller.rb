class PrivateMessagesController < ApplicationController
  before_action :set_private_message, only: [:show, :edit, :update, :destroy]

  # 列表
  def index
		@target_user = User.find(params[:id])
		if current_user.id > @target_user.id
	    @private_messages = PrivateMessage.where(user1_id: @target_user.id, user2_id: current_user.id)
		else
	    @private_messages = PrivateMessage.where(user1_id: current_user.id, user2_id: @target_user.id)
		end
  end

  # 显示
  def show
  end

  # 新建私信对象
  def new
    @private_message = PrivateMessage.new
  end

  # 创建
  def create
		# 创建私信
    @private_message = PrivateMessage.new
		@private_message.content = private_message_params[:content]
		if current_user.id < private_message_params[:target_user_id].to_i
			@private_message.user1_id = current_user.id
			@private_message.user2_id = private_message_params[:target_user_id]
			@private_message.send_class = 1
		else
			@private_message.user1_id = private_message_params[:target_user_id]
			@private_message.user2_id = current_user.id
			@private_message.send_class = 2
		end
    @private_message.save!
    redirect_to :back, notice: 'Private message was successfully created.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_private_message
      @private_message = PrivateMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def private_message_params
      params.permit(:content, :target_user_id)
    end
end
