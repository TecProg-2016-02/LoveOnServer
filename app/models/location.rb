class Location < ActiveRecord::Base
  has_many :users, through: :checkins
end
