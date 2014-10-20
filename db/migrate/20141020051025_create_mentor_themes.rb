class CreateMentorThemes < ActiveRecord::Migration
  def change
    create_table :mentor_themes do |t|
      t.references :user, index: true
      t.references :theme, index: true

      t.timestamps
    end
  end
end
