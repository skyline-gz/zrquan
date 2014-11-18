class Image < ActiveRecord::Base
  belongs_to :wiki, polymorphic: true
end
