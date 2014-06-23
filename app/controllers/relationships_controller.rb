class RelationshipsController < ApplicationController
	def create
		logger.debug("relationships create")
		@user = User.find(params[:id])
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

	end
end
