class MessagesController < ApplicationController

  def index
    # 获取根据日期（yyyy-mm-dd）排序后的哈希
    @messages = current_user.messages.sort_by{ |q| q.created_at }.reverse!.group_by{ |message| message.created_at.to_date }
  end

end

