class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :token_id
      t.text :content
      t.integer :agree_score, default: 0
      t.integer :oppose_score, default: 0
      t.integer :actual_score, default: 0
      t.boolean :anonymous_flag, default: false
      t.references :user, index: true
      t.references :question  # 不设index,用下面的组合索引代替
      t.timestamp :edited_at

      t.timestamps
    end

    add_index :answers, :token_id, unique: true
    add_index :answers, [:question_id, :actual_score]
  end
end
