class Place < ActiveRecord::Base
  belongs_to :user, :touch => true
  belongs_to :location, :touch => true

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users

  default_scope { order('updated_at DESC') }

  validate :not_repeated

  def not_repeated
    u = Place.where(:location_id=>self.location_id)
    u.each {|e|
      if self.location_id == e.location_id
        e.delete
      end
    }
  end

end
