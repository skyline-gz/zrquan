class MessagesController < ApplicationController

  def index
    # 将所有未读消息设为已读
    current_user.messages.where(read_flag: false).each{|unread_message| unread_message.update(read_flag: true)}

    # 获取根据日期（yyyy-mm-dd）排序后的哈希
    @messages = current_user.messages.sort_by{ |q| q.created_at }.reverse!.group_by{ |message| message.created_at.to_date }
  end

end

