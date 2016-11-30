# This class will permit one user block another one

class Block < ActiveRecord::Base
  belongs_to :first_user_interaction, class_name: 'User'
  belongs_to :user_two, class_name: 'User'

  validates :first_user_interaction_id, uniqueness: {scope: :user_two_id, message: "cant block the same user twice"}
  validate :cant_block_myself

  private

  def cant_block_myself
    if self.first_user_interaction.id == self.user_two.id
      errors.add(:expiration_date, "can't block myself")
    else 
      # do nothing
    end
  end
end
