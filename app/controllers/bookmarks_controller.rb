class BookmarksController < ApplicationController

	def create
		@bookmark = current_user.bookmarks.new
		@bookmark.bookmarkable_id = params[:id]
		@bookmark.bookmarkable_type = params[:type]
		@bookmark.save!
		if params[:type] == "Article"
			redirect_to :back, notice: 'Bookmark article succeed.'
		elsif params[:type] == "Question"
			redirect_to :back, notice: 'Bookmark question succeed.'
		end
	end
		
	def destroy
		@bookmark = Bookmark.find_by(user_id: current_user.id, bookmarkable_id: params[:id], bookmarkable_type: params[:type])
		@bookmark.destroy
    if params[:type] == "Article"
			redirect_to :back, notice: 'Unbookmark article succeed.'
		elsif params[:type] == "Question"
			redirect_to :back, notice: 'Unbookmark question succeed.'
		end
	end

end
