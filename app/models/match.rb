class Match < ActiveRecord::Base
  belongs_to :user_one, class_name: 'User', foreign_key: :user_one_id
  belongs_to :user_two, class_name: 'User', foreign_key: :user_two_id

  validates :user_one_id, uniqueness: {scope: :user_two_id, message: "cant interact twice with the same user"}
  before_create { generate_token(:token) }

  private
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end

  private
    def get_user(id)
      if self.user_one_id == id
        return self.user_two
      else
        return self.user_one
      end
    end
end
