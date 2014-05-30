class AddDraftFlagToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :draft_flag, :boolean
  end
end
