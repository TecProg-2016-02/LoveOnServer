class User < ActiveRecord::Base
  attr_accessible :password, :email, :name, :id_facebook, :gender, :birthday
  has_many :checkins
  has_many :locations, through: :checkins

  has_many :interactions_one, class_name: "Interaction", foreign_key: :user_one_id, dependent: :destroy
  has_many :interactions_two, class_name: "Interaction", foreign_key: :user_two_id, dependent: :destroy

  has_many :matches_one, class_name: "Match", foreign_key: :user_one_id, dependent: :destroy
  has_many :matches_two, class_name: "Match", foreign_key: :user_two_id, dependent: :destroy

  before_create { generate_token(:token) }
  before_create { generate_key (:confirm_token) }
  has_secure_password


  validates   :password,
                :on => :create,
                length:{
                    minimum: 6,
                    maximum: 20
                },
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

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end
  def age
    (Date.today - self.birthday).to_i / 365
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

  def matches
    i = Match.where(user_one: self.id) + Match.where(user_two: self.id)

    u = Array.new
    i.each { |e|
      if(e.user_one.id != self.id)
        u << e.user_one
      elsif (e.user_two.id != self.id)
        u << e.user_two
      end
    }
    u
  end

  def matches_token
    i = Match.where(user_one: self.id) + Match.where(user_two: self.id)

    u = Array.new
    i.each { |e|
      if(e.user_one.id != self.id)
        u << e
      elsif (e.user_two.id != self.id)
        u << e
      end
    }
    u
  end

  def stay_online
    self.online = true
  end

  def stay_offline
    self.online = false
  end

# Envia o email e salva o momento q foi enviado
  def send_password_reset
    generate_key(:password_reset_key)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver_now
  end

end
