class Opposition < ActiveRecord::Base
  belongs_to :user
  belongs_to :opposable, polymorphic: true
end
