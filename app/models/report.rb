class Report < ActiveRecord::Base
  belongs_to :reporter, class_name: 'User'
  belongs_to :reported, class_name: 'User'

  validates :reporter_id, uniqueness: {scope: :reported_id, message: "cant report the same user twice"}
  validate :cant_report_myself
  before_save :check_maximum_reports

  validates   :comment,
  presence: true,
  :on => :create,
  length:{
    maximum: 140
  }

  def cant_report_myself
    if self.reporter.id == self.reported.id
      errors.add(:expiration_date, "can't report myself")
    end
  end

end
