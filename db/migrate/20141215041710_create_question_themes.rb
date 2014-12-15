class CreateQuestionThemes < ActiveRecord::Migration
  def change
    create_table :question_themes do |t|
      t.references :target, polymorphic: true, index: true
      t.references :theme, index: true

      t.timestamps
    end
  end
end
