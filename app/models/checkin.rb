class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users
end
