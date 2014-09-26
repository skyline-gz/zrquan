class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :gender, :integer
    add_reference :users, :province, index: true
    add_reference :users, :city, index: true
    add_column :users, :school, :string
    add_column :users, :major, :string
    add_column :users, :industry, :string
    add_column :users, :company, :string
    add_column :users, :position, :string
    add_column :users, :signature, :string
    add_column :users, :description, :text
    add_column :users, :mentor_flag, :boolean, default: false
    add_column :users, :avatar, :string
  end
end