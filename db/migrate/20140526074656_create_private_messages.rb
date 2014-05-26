class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.text :content
      t.references :user1, index: true
      t.references :user2, index: true
      t.integer :send_class
      t.boolean :read_flag

      t.timestamps
    end
  end
end
