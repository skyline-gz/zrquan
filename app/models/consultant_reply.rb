class ConsultantReply < ActiveRecord::Base
  belongs_to :consultant_subject
  belongs_to :user
end
