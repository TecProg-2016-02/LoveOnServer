class CreateCheckin < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.belongs_to :user, index: true
      t.belongs_to :location, index: true
    end
  end
end
