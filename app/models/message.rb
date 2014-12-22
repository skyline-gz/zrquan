class Message < ActiveRecord::Base
  belongs_to :user

  MESSAGE_TYPE = {
    USER_ANSWER_YOUR_FOLLOWING_QUESTION:         10001002,
    USER_COMMENT_YOUR_ANSWER:                    10002003,
    USER_COMMENT_YOUR_FOLLOWING_QUESTION:        10002002,
    USER_REPLY_YOUR_COMMENT:                     10003004,
    USER_FOLLOW_YOU:                             10004001,
    USER_AGREE_YOUR_ANSWER:                      10005003
  }
end
