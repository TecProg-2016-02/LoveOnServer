class Place < ActiveRecord::Base
  belongs_to :user, :touch => true
  belongs_to :location, :touch => true

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users

  default_scope { order('updated_at DESC') }

  validate :not_repeated

  private

  def not_repeated
    places = Place.where(:location_id=>self.location_id)
    places.each {|place|
      if self.location_id == place.location_id
        place.delete
      else 
        # do nothing
      end
    }
  end

end
