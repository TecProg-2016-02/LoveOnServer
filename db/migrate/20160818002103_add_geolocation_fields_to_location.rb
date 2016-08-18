class AddGeolocationFieldsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
    add_column :locations, :distance, :float
  end
end
