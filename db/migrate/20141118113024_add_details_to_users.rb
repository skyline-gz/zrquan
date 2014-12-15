class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :gender, :integer
    add_reference :users, :location, index: true
    add_reference :users, :industry, index: true
    add_reference :users, :latest_company, index: true
    add_column :users, :latest_position, :string
    add_reference :users, :latest_school, index: true
    add_column :users, :latest_major, :string
    add_column :users, :description, :string
    add_column :users, :mobile, :string
    add_column :users, :total_agree_score, :integer
    add_column :users, :reputation, :integer
    add_column :users, :verified_flag, :boolean
    add_column :users, :avatar, :string
  end
end
