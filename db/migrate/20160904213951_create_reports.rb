class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :comment
      t.integer :reporter_id, index: true, foreign_key: true
      t.integer :reported_id, index:true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :blocks, :users, column: :reporter_id
    add_foreign_key :blocks, :users, column: :reported_id
  end
end
