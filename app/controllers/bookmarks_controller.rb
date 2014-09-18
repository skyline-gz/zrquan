class BookmarksController < ApplicationController

  # 收藏
	def create
	  # 创建收藏信息
		@bookmark = current_user.bookmarks.new
		@bookmark.bookmarkable_id = params[:id]
		@bookmark.bookmarkable_type = params[:type]
		@bookmark.save!
		# 跳转到来源页
		if params[:type] == "Article"
			redirect_to :back, notice: 'Bookmark article succeed.'
		elsif params[:type] == "Question"
			redirect_to :back, notice: 'Bookmark question succeed.'
		end
	end
		
  # 取消收藏
	def destroy
		# 删除收藏信息
		@bookmark = Bookmark.find_by(user_id: current_user.id, bookmarkable_id: params[:id], bookmarkable_type: params[:type])
		@bookmark.destroy
		# 跳转到来源页
    if params[:type] == "Article"
			redirect_to :back, notice: 'Unbookmark article succeed.'
		elsif params[:type] == "Question"
			redirect_to :back, notice: 'Unbookmark question succeed.'
		end
	end

end
