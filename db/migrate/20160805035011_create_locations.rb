class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.text :image
      t.string :name

      t.timestamps null: false
    end
  end
end
