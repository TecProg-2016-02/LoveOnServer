class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :id_facebook
      t.string :token
      t.string :password_digest
      t.boolean :email_confirmed
      t.string :confirm_token
      t.string :password_reset_key
      t.datetime :password_reset_sent_at
      t.timestamps null: false
    end
  end
end
