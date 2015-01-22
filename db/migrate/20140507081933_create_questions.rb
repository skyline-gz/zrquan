class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :token_id
      t.string :title
      t.text :content
      t.references :user, index: true
      t.boolean :anonymous_flag, default: false
      t.integer :weight
      t.float :epoch_time, limit: 53
      t.float :hot, limit: 53
      t.integer :answer_count, default: 0
      t.integer :follow_count, default: 0
      t.integer :answer_agree, dafault: 0
      t.references :latest_answer, index: true
      t.integer :latest_qa_time, limit: 8
      t.timestamp :edited_at

      t.timestamps
    end

    add_index :questions, :token_id, unique: true
    add_index :questions, :hot
  end
end
