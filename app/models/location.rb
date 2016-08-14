class Location < ActiveRecord::Base
  has_many :checkins
  has_many :users, through: :checkins
  before_create { generate_token(:token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def male_users(age)
    self.users.where(:gender => 'male').where(["age <= ?", age])
  end

  def female_users(age)
    self.users.where(:gender => 'female').where(["age <= ?", age])
  end

  def all_users(age)
    self.users.where(:gender => 'female').where(["age <= ?", age])
  end
end
