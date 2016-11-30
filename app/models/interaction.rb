# This class will allow the user interact with another

class Interaction < ActiveRecord::Base
  belongs_to :first_user_interaction, class_name: 'User'
  belongs_to :user_two, class_name: 'User'

  validates :first_user_interaction_id, uniqueness: {scope: :user_two_id, message: "cant interact twice with the same user"}
  validate :cant_interact_myself
  before_save :check_match

# This block of code will not permit that you interact to youself
  private
    def cant_interact_myself
      # This rotine will check if the users are the same, if they are, the message that you can't interective with youself will apear, if you are not interective with youself nothing will apear
      if self.first_user_interaction.id == self.user_two.id
        errors.add(:expiration_date, "can't interact with myself")
      else
        render :nothing
      end
    end

# This block of code will show any match you may have
  private
    def match
      user_match = Match.where(first_user_interaction_id: self.first_user_interaction.id, user_two_id: self.user_two.id)
      user_match.first
    end

# This block of code will allow you to have a  view of your match
  private
    def check_match
      user_matched = Interaction.where(first_user_interaction: self.user_two, user_two:self.first_user_interaction)
      unless user_matched.empty?
        # This rotine will check your matches liked back
        if user_matched.first.like && self.like
          self.matched = true
          Match.create(first_user_interaction_id: self.first_user_interaction.id, user_two_id: self.user_two.id)
        else
          render :nothing
        end
      end
    end
end
