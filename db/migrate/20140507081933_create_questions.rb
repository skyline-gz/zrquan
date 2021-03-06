class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, limit: 50
      t.text :content
      t.references :user  # 不设index,用下面的组合索引代替
      t.boolean :anonymous_flag, default: false
      t.integer :weight
      t.float :epoch_time, limit: 53
      t.float :hot, limit: 53
      t.integer :answer_count, default: 0
      t.integer :follow_count, default: 0
      t.integer :answer_agree, dafault: 0
      t.references :hottest_answer, index: true
      t.integer :latest_qa_time, limit: 8
      t.integer :publish_date
      t.timestamp :edited_at

      t.timestamps
    end

    #add_index :questions, [:user_id, :publish_date]
    add_index :questions, [:user_id, :anonymous_flag]
    add_index :questions, [:user_id, :created_at]
  end
end
