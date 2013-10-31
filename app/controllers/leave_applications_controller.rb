class LeaveApplicationsController < ApplicationController
  
  before_action :authenticate_user!

  def new
    @leave_application = LeaveApplication.new(user_id: current_user.id)
    @leave_types = LeaveType.all.to_a 
  end

  def create
    @leave_application = LeaveApplication.new(strong_params)
    if @leave_application.save
      flash[:error] = "Leave Applied Successfully. !Wait till approved"
      current_user.sent_mail_for_approval(from_date: @leave_application.start_at, to_date: @leave_application.end_at) 
    else
      
      @leave_types = LeaveType.all.to_a 
      flash[:error] = @leave_application.errors.full_messages.join("\n")
      render 'new' and return
    end
    redirect_to public_profile_user_path(current_user) and return 
  end 
  
  def view_leave_status
    @pending_leave = LeaveApplication.where(leave_status: 'Pending')
    @approved_leave = LeaveApplication.where(leave_status: 'Approved') 
  end

  def strong_params
    safe_params = [
                   :user_id, :leave_type_id, :start_at, 
                   :end_at, :contact_number, :number_of_days,
                   :reason, :reject_reason, :leave_status
                  ]
    params.require(:leave_application).permit(*safe_params) 
  end

  def cancel_leave
    leave_application = LeaveApplication.where(id: params[:id]).first
    leave_application.leave_status = 'Rejected' 
    leave_application.save
    leave_application.process_reject_application 
    render :nothing => true
  end

  def approve_leave
    leave_application = LeaveApplication.where(id: params[:id]).first
    leave_application.leave_status = 'Approved' 
    leave_application.save!
    leave_application.process_accept_application 
    render :nothing => true
  end  
end
