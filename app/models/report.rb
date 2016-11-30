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

# This function will permit taht you can't report yourself
  def cant_report_myself
    # This line will check if the id that you want report is equal of yours id
    if self.reporter.id == self.reported.id
      # This is a message that show if you want report yourself
      errors.add(:expiration_date, "can't report myself")
    # Will render nothing if you dont fit on this
    else
      # do nothing
    end
  end

  def check_maximum_reports
    # Will check the reports of the user
    user_report = Report.where(reported:self.reported)
    # Will check how many reports has been made
    unless user_report.empty?
      # Will check how many reports that user has
      if user_report.length >= 5
        # If the user fit in, he will be blocked
        self.reported.block_account
      # Nothing will happen if they don't fit
      else
        render :nothing
      end
    end
  end

end
