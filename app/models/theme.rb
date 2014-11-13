class Theme < ActiveRecord::Base
  belongs_to :substance, polymorphic: true
end
