class MessagesAdapter
  include Sidekiq::Worker

  ACTION_TYPE = {
      USER_ANSWER_QUESTION:                   1,
      USER_COMMENT_QUESTION:                  2,
      USER_COMMENT_ANSWER:                    3,
      USER_REPLY_COMMENT:                     4,
      USER_FOLLOW_USER:                       5,
      USER_AGREE_ANSWER:                      6
  }

  def perform(type, *args)
    case type
      when ACTION_TYPE[:USER_COMMENT_QUESTION]
        user = User.find(args[0])
        question_obj = Question.find(args[1])


        logger.info(type)
        logger.info(args)
        logger.info(args[0])
        logger.info(args[1])
        logger.info(Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_FOLLOWING_QUESTION])
        question_obj.followers.each do |follower|
          if follower.user_msg_setting.commented_flag
            follower.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_FOLLOWING_QUESTION], extra_info1_id: user.id, extra_info1_type: 'User',
                                                       extra_info2_id: question_obj.id, extra_info2_type: 'Question')
            realtime_push_to_client(follower.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_FOLLOWING_QUESTION],
                                                              obj1: user, obj2: question_obj})
          end
        end
      else
    end
  end

  private
  def realtime_push_to_client (temp_access_token, obj)
    FayeClient.send("/message/#{temp_access_token}", obj)
  end
end