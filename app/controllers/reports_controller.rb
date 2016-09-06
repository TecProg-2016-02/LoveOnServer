class ReportsController < ApplicationController

  def create
    report = Report.create(:reporter_id =>params[:reporter_id],
      :reported_id => params[:reported_id], :comment => params[:comment])

    if report.save
      render json: report
    end
  end

end
