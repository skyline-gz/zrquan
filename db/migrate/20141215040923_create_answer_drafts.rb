class CreateAnswerDrafts < ActiveRecord::Migration
  def change
    create_table :answer_drafts do |t|
      t.text :content
      t.references :user, index: true
      t.references :question, index: true

      t.timestamps
    end
  end
end
