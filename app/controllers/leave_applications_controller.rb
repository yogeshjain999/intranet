class LeaveApplicationsController < ApplicationController
  
  before_action :authenticate_user!

  def new
    @leave_application = LeaveApplication.new(user_id: current_user.id)
    
  end

  def create
    @leave_application = LeaveApplication.new(strong_params)
    if @leave_application.save
      flash[:error] = "Leave Applied Successfully. !Wait till approved" 
    else
      flash[:error] = @leave_application.errors.full_messages.join("\n")
    end
  end 

  def strong_params
    safe_params = [
                   :user_id, :leave_type_id, :start_at, 
                   :end_at, :contact_number, :number_of_days,
                   :reason, :reject_reason, :leave_status
                  ]
    params.require(:leave_application).permit(*safe_params) 
  end
end
