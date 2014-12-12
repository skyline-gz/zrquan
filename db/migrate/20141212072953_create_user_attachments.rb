class CreateUserAttachments < ActiveRecord::Migration
  def change
    create_table :user_attachments do |t|
      t.references :user, index: true
      t.references :attachable, polymorphic: true, index: true
      t.string :url
      t.string :original_name
      t.string :content_type
      t.string :attach_type
      t.integer :size

      t.timestamps
    end
  end
end
