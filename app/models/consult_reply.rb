class ConsultReply < ActiveRecord::Base
  belongs_to :consult_subject
  belongs_to :user

	validates :content, presence: true, on: :create

  validates :content, length: {in: 1..20000}
end
