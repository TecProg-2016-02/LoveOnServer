class Checkin < ActiveRecord::Base
  belongs_to :user, :touch => true
  belongs_to :location

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users

  validate :checkin_once

  def checkin_once
    u = Checkin.all
    u.each {|e|
      if self.user_id == e.user_id && self.location_id == e.location_id
        if e.updated_at > (DateTime.current - 30.minutes)
          errors.add(:user_id, "Não é possivel fazer checkin, aguarde o tempo necessario")
        end
        e.delete
      end
    }
  end

end
