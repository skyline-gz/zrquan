require 'return_code'

class SearchController < ApplicationController

  SUPPORT_TYPE = %w('Question', 'User', 'Post', 'Theme')

  # type 类型，见 SUPPORT_TYPE
  # q    搜索关键字
  def index
    type = params[:type]
    key_word = params[:q]
    if key_word == nil or key_word.length == 0
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS} and return
    end
    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      search = type.constantize.search do
        fulltext key_word
      end
      @items = search.results
      render :json => {:result => @items}
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  def list

  end
end