class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :gender, :integer
    add_reference :users, :province, index: true
    add_reference :users, :city, index: true
    add_reference :users, :latest_company, index: true
    add_column :users, :latest_position, :string
    add_reference :users, :latest_school, index: true
    add_column :users, :latest_major, :string
    add_column :users, :signature, :string
    add_column :users, :description, :text
    add_column :users, :verified_flag, :boolean
    add_column :users, :avatar, :string
  end
end
