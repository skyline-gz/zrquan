class RelationshipsController < ApplicationController
	before_action :set_user, only: [:create, :destroy]

  # 创建
	def create
		logger.debug("relationships created")
		current_user.follow!(@user)
		redirect_to users_path, notice: 'Following user succeed.'
	end
		
	# 删除
	def destroy
		current_user.unfollow(@user)
    redirect_to users_path, notice: 'Unfollow user succeed.'
	end

	private
		# Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end