class LeaveApplicationsController < ApplicationController
  def new
    @leave_application = LeaveApplication.new
  end
end
