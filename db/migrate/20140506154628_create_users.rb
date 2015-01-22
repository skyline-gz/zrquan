class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :mobile,             null: false, default: "", limit: 20  # set limit to fix mysql utf8mb4 error
      t.string :encrypted_password, null: false, default: ""

      ## Trackable
      t.integer  :sign_in_count, default: 0
      # 最近一次使用用户密码登陆的时间
      t.datetime :current_sign_in_at

      t.string  :name
      t.integer :gender
      t.references  :location, index: true
      t.references  :industry, index: true
      t.references  :latest_career, index: true
      t.references  :latest_education, index: true
      t.string  :latest_company_name
      t.string  :latest_position
      t.string  :latest_school_name
      t.string  :latest_major
      t.string  :description
      t.boolean :verified_flag
      t.string  :avatar

      t.timestamps
    end

    add_index :users, :mobile,  unique: true
  end
end
