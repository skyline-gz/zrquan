class CreateQuestionFollows < ActiveRecord::Migration
  def change
    create_table :question_follows do |t|
      t.references :question, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
