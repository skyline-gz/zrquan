class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :mobile,             null: false, default: "", limit: 20  # set limit to fix mysql utf8mb4 error
      t.string :encrypted_password, null: false, default: ""

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at

      t.integer :token_id
      t.string  :url_id
      t.string  :name
      t.integer :gender
      t.references  :location, index: true
      t.references  :industry, index: true
      t.references  :latest_career, index: true
      t.references  :latest_education, index: true
      t.string  :description
      t.boolean :verified_flag
      t.string  :avatar

      t.timestamps
    end

    add_index :users, :mobile,  unique: true
    add_index :users, :token_id, unique: true
    add_index :users, :url_id, unique: true
  end
end
