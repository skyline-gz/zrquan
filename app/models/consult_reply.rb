class ConsultReply < ActiveRecord::Base
  belongs_to :consult_subject
  belongs_to :user
end
