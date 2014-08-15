class NewsFeed < ActiveRecord::Base
  belongs_to :feedable, polymorphic: true
end
