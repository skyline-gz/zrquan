class CreateUserThemeStats < ActiveRecord::Migration
  def change
    create_table :user_theme_stats do |t|
      t.references :user, index: true
      t.references :theme, index: true
      t.integer :question_count
      t.integer :answer_count
      t.integer :total_agree_score
      t.integer :apply_consult_count
      t.string :accept_consult_count
      t.integer :fin_mentor_consult_count
      t.integer :mentor_score_sum
      t.integer :score_consult_count
      t.integer :mentor_score_avg
      t.integer :reputation

      t.timestamps
    end
  end
end
