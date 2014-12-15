class QuestionDraft < ActiveRecord::Base
  belongs_to :user
  has_many :question_themes, as: :target
end
