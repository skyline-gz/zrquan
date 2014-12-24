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
      when ACTION_TYPE[:USER_ANSWER_QUESTION]
        user = User.find(args[0])
        question_obj = Question.find(args[1])
        question_user = question_obj.user
        question_obj.followers.each do |follower|
          # 1.自己回答自己关注的问题时，不发消息
          is_self = (user.id == follower.id)
          if question_user.user_msg_setting.answer_flag && !is_self
            question_user.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_ANSWER_YOUR_FOLLOWING_QUESTION], extra_info1_id: user.id, extra_info1_type: 'User',
                                            extra_info2_id: question_obj.id, extra_info2_type: 'Question')
            push_to_client(follower.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_ANSWER_YOUR_FOLLOWING_QUESTION], unread_num:question_user.unread_messages.length,
                                                        obj1: extract_user(user), obj2: extract_question(question_obj)})
          end
        end
      when ACTION_TYPE[:USER_COMMENT_QUESTION]
        user = User.find(args[0])
        question_obj = Question.find(args[1])
        reply_user = nil
        if args[2]
          replied_comment_obj = Comment.find(args[2])
          reply_user = replied_comment_obj.user
        end
        question_obj.followers.each do |follower|
          # １.即是关注问题者，又是被回复者时，不发消息
          is_reply_user_follower = (!!reply_user and (reply_user.id == follower.id))
          # 2.自己评论自己关注的问题时，不发消息
          is_self = (user.id == follower.id)
          if follower.user_msg_setting.commented_flag && !is_reply_user_follower && !is_self
            follower.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_FOLLOWING_QUESTION], extra_info1_id: user.id, extra_info1_type: 'User',
                                                       extra_info2_id: question_obj.id, extra_info2_type: 'Question')
            push_to_client(follower.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_FOLLOWING_QUESTION], unread_num:follower.unread_messages.length,
                                                              obj1: extract_user(user), obj2: extract_question(question_obj)})
          end
        end
      when ACTION_TYPE[:USER_COMMENT_ANSWER]
        user = User.find(args[0])
        answer_obj = Answer.find(args[1])
        reply_user = nil
        if args[2]
          replied_comment_obj = Comment.find(args[2])
          reply_user = replied_comment_obj.user
        end
        answer_user = answer_obj.user
        answer_question = answer_obj.question
        # １.即是答案所有者，又是被回复者时，不发消息
        is_reply_user_follower = (!!reply_user and (reply_user.id == answer_user.id))
        # 2.自己评论自己的答案时，不发消息
        is_self = (user.id == answer_user.id)
        if answer_user.user_msg_setting.commented_flag && !is_reply_user_follower && !is_self
          answer_user.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_ANSWER], extra_info1_id: user.id, extra_info1_type: 'User',
                                    extra_info2_id: answer_question.id, extra_info2_type: 'Question')
          push_to_client(answer_user.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_COMMENT_YOUR_ANSWER], unread_num:answer_user.unread_messages.length,
                                                               obj1: extract_user(user), obj2: extract_question(answer_question)})
        end
      when ACTION_TYPE[:USER_REPLY_COMMENT]
        user = User.find(args[0])
        question_obj = Question.find(args[1])
        replied_comment_obj = Comment.find(args[2])
        reply_user = replied_comment_obj.user
        if reply_user.user_msg_setting.commented_flag
          reply_user.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_REPLY_YOUR_COMMENT], extra_info1_id: user.id, extra_info1_type: 'User',
                                       extra_info2_id: question_obj.id, extra_info2_type: 'Question')
          push_to_client(reply_user.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_REPLY_YOUR_COMMENT], unread_num:reply_user.unread_messages.length,
                                                                  obj1: extract_user(user), obj2: extract_question(question_obj)})
        end
      when ACTION_TYPE[:USER_FOLLOW_USER]
        user0 = User.find(args[0])
        user1 = User.find(args[1])
        if user1.user_msg_setting.followed_flag
          user1.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_FOLLOW_YOU], extra_info1_id: user0.id, extra_info1_type: 'User',)
          push_to_client(user1.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_FOLLOW_YOU], obj1: extract_user(user0), unread_num:user1.unread_messages.length,})
        end
      when ACTION_TYPE[:USER_AGREE_ANSWER]
        user = User.find(args[0])
        answer_obj = Answer.find(args[1])
        answer_user = answer_obj.user
        answer_question = answer_obj.question
        if answer_user.user_msg_setting.agreed_flag
          answer_user.messages.create!(msg_type: Message::MESSAGE_TYPE[:USER_AGREE_YOUR_ANSWER], extra_info1_id: user.id, extra_info1_type: "User",
                                        extra_info2_id: answer_question.id, extra_info2_type: 'Question')
          push_to_client(answer_user.temp_access_token, {type:  Message::MESSAGE_TYPE[:USER_AGREE_YOUR_ANSWER], unread_num:answer_user.unread_messages.length,
                                                         obj1: extract_user(user), obj2: extract_question(answer_question)})
        end
      else
    end
  end

  private
  def push_to_client (temp_access_token, obj)
    FayeClient.send("/message/#{temp_access_token}", obj)
  end

  def extract_user(user)
    hash = user.as_json
    user_name = ApplicationController.helpers.generate_name(hash['first_name'], hash['last_name'])
    hash.slice!('token_id', 'url_id')
    hash.merge!('name' => user_name)
  end

  def extract_question(question)
    hash = question.as_json
    hash.slice('title', 'token_id')
  end
end