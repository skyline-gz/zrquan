class Relationship < ActiveRecord::Base
  belongs_to :following_user, class_name: "User"
  belongs_to :follower, class_name: "User"
end
