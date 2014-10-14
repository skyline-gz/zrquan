class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :msg_type
      t.references :user, index: true
      t.references :extra_info1, polymorphic: true, index: true
      t.references :extra_info2, polymorphic: true, index: true
      t.timestamps
    end
  end
end
