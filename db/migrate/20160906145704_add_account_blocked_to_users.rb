class AddAccountBlockedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_blocked, :boolean, default: false
  end
end
