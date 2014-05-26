class Invitation < ActiveRecord::Base
  belongs_to :question
  belongs_to :mentor, class_name: "User"
end
