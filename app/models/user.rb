class User < ActiveRecord::Base
  attr_accessible :password, :email, :name, :gender, :birthday,
    :avatar, :description, :district, :city, :height, :weight, :gallery,
    :search_male, :search_female, :background, :search_range

  serialize :gallery
  has_one :checkin
  has_one :location, through: :checkin
  has_many :places, -> { order 'updated_at DESC' }
  has_many :locations, through: :places

  has_many :interactions_one, class_name: "Interaction", foreign_key: :user_one_id, dependent: :destroy
  has_many :interactions_two, class_name: "Interaction", foreign_key: :user_two_id, dependent: :destroy

  has_many :block_one, class_name: "Block", foreign_key: :user_one_id, dependent: :destroy
  has_many :block_two, class_name: "Block", foreign_key: :user_two_id, dependent: :destroy

  has_many :matches_one, class_name: "Match", foreign_key: :user_one_id, dependent: :destroy
  has_many :matches_two, class_name: "Match", foreign_key: :user_two_id, dependent: :destroy

  has_many :reporter, class_name: "Report", foreign_key: :reporter_id, dependent: :destroy
  has_many :reported, class_name: "Report", foreign_key: :reported_id, dependent: :destroy

  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_create { generate_token(:token) }
  before_create { generate_key (:confirm_token) }
  has_secure_password
  has_many :reports

  validates   :password,
                :on => :create,
                presence: true

  validates   :email,
              :on => :create,
              presence: true,
              uniqueness: true,
              format: {
                with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
              }

  def to_param
    email
  end


  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def user_follows
    u = Array.new
    following = self.following
    blocks = Block.where(user_one: self.id) + Block.where(user_two: self.id)
    following.each { |e|
      if(!blocks.empty?)
        blocks.each { |t|
          if(e.id != t.user_one.id && e.id != t.user_two.id)
              u << e
          end
        }
      else
        u << e
      end
    }
    u
  end

  def follow_user
    u = Array.new
    followers = self.followers
    blocks = Block.where(user_one: self.id) + Block.where(user_two: self.id)
    followers.each { |e|
      if(!blocks.empty?)
        blocks.each { |t|
          if(e.id != t.user_one.id && e.id != t.user_two.id)
              u << e
          end
        }
      else
        u << e
      end
    }
    u
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def age
    if self.birthday
      self.age = (Date.today - self.birthday).to_i / 365
    end
  end
# Gerador de chaves
  def generate_key(column)
    begin
      self[column] = SecureRandom.base64(4).gsub!(/[^0-9A-Za-z]/, '')
    end while User.exists?(column => self[column])
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def last_place
    self.locations.last
  end

  def blocks
    i = Block.where(user_one: self.id)

    u = Array.new
    i.each { |e|
      u << e.user_two
    }
    u
  end

  def blocked?(other_user)
    blocks.include?(other_user)
  end

  def matches
    i = Match.where(user_one: self.id) + Match.where(user_two: self.id)
    blocks = Block.where(user_one: self.id) + Block.where(user_two: self.id)
    u = Array.new
    i.each { |e|
      if(e.user_one.id != self.id)
        if(!blocks.empty?)
          blocks.each { |t|
            if(e.user_one.id != t.user_one.id &&e.user_one.id != t.user_two.id)
              u << e.user_one
            end
          }
        else
          u << e.user_one
        end
      elsif (e.user_two.id != self.id)
        if(!blocks.empty?)
          blocks.each { |t|
            if(e.user_two.id != t.user_one.id && e.user_one.id != t.user_two.id)
              u << e.user_two
            end
          }
        else
          u << e.user_two
        end
      end
    }
    u
  end

  def matches_token
    i = Match.where(user_one: self.id) + Match.where(user_two: self.id)
    blocks = Block.where(user_one: self.id) + Block.where(user_two: self.id)
    u = Array.new
    i.each { |e|
      if(e.user_one.id != self.id)
        if(!blocks.empty?)
          blocks.each { |t|
            if(e.user_one.id != t.user_one.id &&e.user_one.id != t.user_two.id)
              u << e
            end
          }
        else
          u << e
        end
      elsif (e.user_two.id != self.id)
        if(!blocks.empty?)
          blocks.each { |t|
            if(e.user_two.id != t.user_one.id && e.user_one.id != t.user_two.id)
              u << e
            end
          }
        else
          u << e
        end
      end
    }
    u
  end

  def matched?(user)
    i = Match.where(user_one: self.id) + Match.where(user_two: self.id)
    i.each { |e|
      if(e.user_one.id == user.id)
        return true
      elsif (e.user_two.id == user.id)
        return true
      end
    }
    return false
  end

  def stay_online
    self.status = true
    save!(:validate => false)
  end

  def stay_offline
    self.status = false
    save!(:validate => false)
  end

# Envia o email e salva o momento q foi enviado
  def send_password_reset
    generate_key(:password_reset_key)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver_now
  end

  def block_account
    self.account_blocked = true
    save!(:validate => false)
  end
end
