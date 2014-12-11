class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  def self.has?(user_id, type, id)
    Bookmark.find_by(user_id: user_id, bookmarkable_id: id, bookmarkable_type: type) != nil
  end
end
