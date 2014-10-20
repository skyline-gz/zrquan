class ConsultTheme < ActiveRecord::Base
  belongs_to :consult_subject
  belongs_to :theme
end
