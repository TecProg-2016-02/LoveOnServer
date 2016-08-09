class Location < ActiveRecord::Base
  has_many :checkins
  has_many :users, through: :checkins

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
