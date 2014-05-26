class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :question, index: true
      t.references :mentor, index: true

      t.timestamps
    end
  end
end
