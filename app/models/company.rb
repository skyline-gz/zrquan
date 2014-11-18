class Company < ActiveRecord::Base
  belongs_to :city
  belongs_to :industry
  belongs_to :parent_company
end
