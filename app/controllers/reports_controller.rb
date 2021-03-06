class ReportsController < ApplicationController

  # this bloc of code will report an user
  def create
    report = Report.create(:reporter_id =>params[:reporter_id],
      :reported_id => params[:reported_id], :comment => params[:comment])

    # if the report is valid, it will be saved and render in json format
    if report.save
      render json: report
    else
      # do nothing
    end
  end

end
