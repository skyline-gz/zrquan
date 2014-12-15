class QuestionTheme < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :theme
end
