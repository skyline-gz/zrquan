class CreateQuestionThemes < ActiveRecord::Migration
  def change
    create_table :question_themes do |t|
      t.references :question, index: true
      t.integer    :hot
      t.references :theme, index: true

      t.timestamps
    end
  end
end
