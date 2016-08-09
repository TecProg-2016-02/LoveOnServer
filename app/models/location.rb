class Location < ActiveRecord::Base
  has_many :checkins
  has_many :users, through: :checkins
  before_create { generate_token(:token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def male_users(user)
    i = self.users.where(:gender => 'male')
    u = Array.new
    i.each { |e|
      if(e.id != user.id)
        u << e
      end
    }
    u
  end

  def female_users(user)
    i = self.users.where(:gender => 'female')
    u = Array.new
    i.each { |e|
      if(e.id != user.id)
        u << e
      end
    }
    u
  end
end
