class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :username
      t.string :email
      t.string :authentication_token
      t.string :secondary_token
      t.datetime :token_expires_at

      t.timestamps
    end
    add_index :authentications, [:email, :provider], :unique => true
    add_index :authentications, [:uid, :provider], :unique => true
  end
end
