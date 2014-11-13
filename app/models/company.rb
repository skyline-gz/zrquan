class Company < ActiveRecord::Base
  belongs_to :city
  belongs_to :industry
  belongs_to :corporate_group
end
