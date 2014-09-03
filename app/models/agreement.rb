class Agreement < ActiveRecord::Base
  belongs_to :user
  belongs_to :agreeable, polymorphic: true
end
