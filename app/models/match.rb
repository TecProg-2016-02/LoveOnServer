class Match < ActiveRecord::Base
  belongs_to :first_user_interaction, class_name: 'User', foreign_key: :first_user_interaction_id
  belongs_to :user_two, class_name: 'User', foreign_key: :user_two_id

  validates :first_user_interaction_id, uniqueness: {scope: :user_two_id, message: "cant interact twice with the same user"}
  before_create { generate_token(:token) }

  private
    def generate_token(column)
      # This part will select a person by using base 64 to make this selection
      begin
        self[column] = SecureRandom.urlsafe_base64
      end
        while User.exists?(column => self[column])
    end

  private
    # This part will check if it is interacting with the same person
    def get_user(id)
      if self.first_user_interaction_id == id
        return self.user_two
      else
        return self.first_user_interaction
      end
    end
end
