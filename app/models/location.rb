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
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end

  private
    def male_users(age)
      self.users.where(:gender => 'male').where(["age <= ?", age])
    end

  private
    def female_users(age)
      self.users.where(:gender => 'female').where(["age <= ?", age])
    end

  private
    def all_users(age)
      self.users.where(:gender => 'female').where(["age <= ?", age])
    end
end
