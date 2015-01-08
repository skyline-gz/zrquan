class QuestionTheme < ActiveRecord::Base
  belongs_to :question
  belongs_to :theme
end
