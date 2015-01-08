class PostTheme < ActiveRecord::Base
  belongs_to :post
  belongs_to :theme
end
