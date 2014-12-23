require 'return_code.rb'

class BookmarksController < ApplicationController

  # 支持收藏的类型
  SUPPORT_TYPE = %w('Question')

  # 收藏
	def create
    type = params[:type]
    id = params[:id]
    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      @bookmark_related_obj = type.constantize.find_by_token_id(id)
      if can? :bookmark, @bookmark_related_obj
        # 创建收藏信息
        @bookmark = current_user.bookmarks.new
        @bookmark.bookmarkable_id = @bookmark_related_obj.id
        @bookmark.bookmarkable_type = type
        @bookmark.save!
        render :json => {:code => ReturnCode::S_OK}
      else
        render :json => {:code => ReturnCode::FA_UNAUTHORIZED}
      end
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
	end
		
  # 取消收藏
	def destroy
    type = params[:type]
    id = params[:id]
    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      @bookmark_related_obj = type.constantize.find_by_token_id(id)
      if can? :unbookmark, @bookmark_related_obj
        # 删除收藏信息
        @bookmark = Bookmark.find_by(user_id: current_user.id, bookmarkable_id: @bookmark_related_obj.id, bookmarkable_type: type)
        @bookmark.destroy
        render :json => {:code => ReturnCode::S_OK}
      else
        render :json => {:code => ReturnCode::FA_UNAUTHORIZED}
      end
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

end
