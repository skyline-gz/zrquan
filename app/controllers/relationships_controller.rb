class RelationshipsController < ApplicationController
	before_action :set_user, only: [:create, :destroy]

	def create
		logger.debug("relationships created")
		begin
			current_user.follow!(@user)
			respond_to do |format|
				format.html { redirect_to users_path, notice: 'Following user succeed.' }
		    format.json { render :show, status: :ok, location: @user }
			end
		rescue => e
			respond_to do |format|
				format.html { render :show }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
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
