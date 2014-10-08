class ConsultReply < ActiveRecord::Base
  belongs_to :consult_subject
  belongs_to :user

	validates :content, presence: true, on: :create
end
