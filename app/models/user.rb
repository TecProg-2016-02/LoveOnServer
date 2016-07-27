class User < ActiveRecord::Base
  attr_accessible :password, :email, :name, :id_facebook
  

  before_create { generate_token(:token) }
  before_create { generate_key (:key) }
  has_secure_password

  validates_date  :birthday,
                  on_or_after: lambda { 125.years.ago },
                  on_or_before: lambda { 18.years.ago }

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

# Envia o email e salva o momento q foi enviado
  def send_password_reset
    generate_key(:password_reset_key)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver_now
  end

end
