class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_id, :integer
    add_column :users, :url_id, :string
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_reference :users, :location, index: true
    add_reference :users, :industry, index: true
    add_reference :users, :latest_career, index: true
    add_reference :users, :latest_education, index: true
    add_column :users, :description, :string
    add_column :users, :mobile, :string
    add_column :users, :verified_flag, :boolean
    add_column :users, :avatar, :string

    add_index :users, :token_id, unique: true
    add_index :users, :url_id, unique: true
  end
end
