# This class will list the gender chosen by the locality

class Location < ActiveRecord::Base
  has_many :checkins
  has_many :users, through: :checkins
  before_create { generate_token(:token) }

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  private
    # This part will generate a location token while the user exists
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end

      while User.exists?(column => self[column])
    end

  private
    # This part show male people, according to age
    def male_users(age)
      self.users.where(:gender => 'male').where(["age <= ?", age])
    end

  private
    # This part show female people, according to age
    def female_users(age)
      self.users.where(:gender => 'female').where(["age <= ?", age])
    end

  private
    # This part will show all users
    def all_users(age)
      self.users.where(:gender => 'female').where(["age <= ?", age])
    end
end
