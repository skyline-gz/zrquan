class IndustryJobCategory < ActiveRecord::Base
  belongs_to :industry
  belongs_to :job_category
end
