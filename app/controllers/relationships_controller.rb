class RelationshipsController < ApplicationController
	before_action :set_user, only: [:create, :destroy]

	def create
		logger.debug("relationships created")
		current_user.follow!(@user)
		respond_to do |format|
			format.html { redirect_to users_path, notice: 'Following user succeed.' }
	    format.json { redirect_to users_path, status: :ok, location: @user }
		end
	end
		
	def destroy
		current_user.unfollow(@user)
		respond_to do |format|
      format.html { redirect_to users_path, notice: 'Unfollow user succeed.' }
      format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
