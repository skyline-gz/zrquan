class MessagesController < ApplicationController

  DEFAULT_SHOW_LENGTH = 20
  PULL_TO_REFRESH_LENGTH = 20

  def index
    # 将所有未读消息设为已读
    current_user.messages.where(read_flag: false).each{|unread_message| unread_message.update(read_flag: true)}
    @messages = get_ordered_messages
    # 显示前20条
    @messages = @messages[0..DEFAULT_SHOW_LENGTH - 1]
    @messages = group_messages(@messages)
  end

  def list
    last_id = params[:last_id]
    @messages = get_ordered_messages
    start = 0
    if last_id
      @messages.each_with_index {|q, i|
        if q.token_id == last_id.to_i
          start = i
          next
        end
      }
    end
    # 加载20条
    @messages = @messages[(start + 1)..(start + PULL_TO_REFRESH_LENGTH)]
    @messages = group_messages(@messages)
    render 'messages/list'
  end

  private
  def get_ordered_messages
    current_user.messages.sort_by{ |q| q.created_at }.reverse!
  end

  # 获取根据日期（yyyy-mm-dd）排序后的哈希
  def group_messages(messages)
    messages.group_by{ |message| message.created_at.to_date }
  end
end

