class CreateFollowingActStats < ActiveRecord::Migration
  def change
    create_table :following_act_stats do |t|
      t.references :user  # 不设index,用下面的组合索引代替
      t.integer :following_act_count
      t.integer :recent_days
    end

    add_index :following_act_stats, [:user_id, :recent_days]
    add_index :following_act_stats, :recent_days
  end
end
