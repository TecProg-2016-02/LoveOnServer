class Place < ActiveRecord::Base
  belongs_to :user, :touch => true
  belongs_to :location

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users

  default_scope { order('updated_at DESC') }

end
