class Career < ActiveRecord::Base
  belongs_to :user
  belongs_to :industry
  belongs_to :company
end
