class Checkin < ActiveRecord::Base
  belongs_to :user, :touch => true
  belongs_to :location

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users

  validate :checkin_once

  private

  def checkin_once
    user_checkins = Checkin.where(:user_id=>self.user_id)
    user_checkins.each {|checkin|
      if self.user_id == checkin.user_id
        checkin.delete
      else
        # do nothing
      end
    }
  end

end
