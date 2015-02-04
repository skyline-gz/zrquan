class CreateAnswerDrafts < ActiveRecord::Migration
  def change
    create_table :answer_drafts do |t|
      t.text :content
      t.references :user
      t.references :question, index: true

      t.timestamps
    end

    add_index :answer_drafts, [:user_id, :created_at]
  end
end
