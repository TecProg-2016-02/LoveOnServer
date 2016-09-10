class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :token
      t.string :id_social
      t.string :password_digest
      t.boolean :email_confirmed
      t.string :confirm_token
      t.string :password_reset_key
      t.datetime :password_reset_sent_at
      t.string :gender
      t.date :birthday
      t.string :description
      t.text :avatar
      t.boolean :status, :default => false
      t.integer :age
      t.float :weight
      t.float :height
      t.string :city
      t.string :district
      t.boolean :search_male
      t.boolean :search_female
      t.integer :search_range
      t.text :gallery, array: true, default: []
      t.timestamps null: false
    end
  end
end
