class CreateQuestionDrafts < ActiveRecord::Migration
  def change
    create_table :question_drafts do |t|
      t.string :title
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
