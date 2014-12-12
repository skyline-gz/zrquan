class UserAttachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachable, polymorphic: true
end
