class Block < ActiveRecord::Base
  belongs_to :user_one, class_name: 'User'
  belongs_to :user_two, class_name: 'User'

  validates :user_one_id, uniqueness: {scope: :user_two_id, message: "cant block the same user twice"}
  validate :cant_block_myself

  private

  def cant_block_myself
    if self.user_one.id == self.user_two.id
      errors.add(:expiration_date, "can't block myself")
    end
  end
end
