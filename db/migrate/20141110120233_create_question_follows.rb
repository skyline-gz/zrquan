class CreateQuestionFollows < ActiveRecord::Migration
  def change
    create_table :question_follows do |t|
      t.references :question, index: true
      t.references :user

      t.timestamps
    end

    add_index :question_follows, [:user_id, :created_at]
  end
end
