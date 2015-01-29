class CreateUserCountStats < ActiveRecord::Migration
  def change
    create_table :user_count_stats do |t|
      t.integer :date_id
      t.integer :user_count
      t.integer :max_user_id
    end

    add_index :user_count_stats, :date_id, unique: true
  end

end
