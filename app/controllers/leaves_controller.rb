class LeavesController < ApplicationController
  before_filter :current_organization
  load_and_authorize_resource

  def index        
    @leaves = current_organization.leaves.accessible_by(current_ability).desc(:id).page(params[:page])
    Kaminari.paginate_array(@leaves).page(params[:page])
    current_user.leave_details.each do |l|
      if l.assign_date.year == Date.today.year
        @leave_details = l
    end
    end
    @leave_types = current_organization.leave_types
    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @leaves }
    end
  end

  def show
    @leave = Leave.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @leave }
    end
  end

  def new
    @leave = Leave.new
    @profile = current_user.profile
  end

  def create
    @leave = Leave.new(params[:leave])
    @leave.user = current_user
    @leave.organization = current_organization
    available_leaves = available_leaves(@leave.user)
p "the variable is,"
p available_leaves 
    @leave.access_params(params[:leave], available_leaves)
    @leave.status = "Pending"
    respond_to do |format|
      if @leave.save
        if current_user.roles == 'HR'
          user_role = current_organization.users.where(:roles => 'Admin').collect(&:email)
          UserMailer.leaveReport(@leave, current_user, user_role).deliver
        elsif current_user.roles == 'Manager'
          user_role = current_organization.users.in(:roles => ['HR', 'Admin']).collect(&:email)
          UserMailer.leaveReport(@leave, current_user, user_role).deliver
        elsif current_user.roles == 'Employee' && current_user.manager.nil?
          user_role = current_organization.users.in(:roles => ['HR', 'Admin']).collect(&:email)
          UserMailer.leaveReport(@leave, current_user, user_role).deliver
        else
          user_role = current_organization.users.in(:roles => ['Admin', 'HR']).collect(&:email).push(current_user.manager.email)
          UserMailer.leaveReport(@leave,current_user, user_role).deliver
          format.json {render json: @leave, status: :created}
        end
	format.html {redirect_to leaves_path, notice: 'Your request has been noted' }
        format.json {render json: @leave, status: :created}
      else
        @profile = current_user.profile
        format.html {render action: "new"}
	format.json { render json: @leave.errors, status: :unprocessable_entity }
      end
  end
  end

  def edit
    @leave = Leave.find(params[:id])    
  end

  def update
    @leave = Leave.find(params[:id])
    @leave.access_params(params[:leave], available_leaves(@leave.user))
    respond_to do |format|
      if @leave.update_attributes(params[:leave])
        format.html { redirect_to leaves_path, notice: 'Leave is successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave.errors, status: :unprocessable_entity }
      end
    end    
  end

  def approve
    @leave = Leave.find(params[:id])
    if request.put?
      available_leaves = available_leaves(@leave.user)
      @leave.access_params(params[:leave],available_leaves)
      @leave.status = "Approved"
      respond_to do |format|
        if @leave.update_attributes(params[:leave])
          UserMailer.approveLeave(@leave, current_user).deliver    
          num_day = @leave.number_of_days
          leave_details = @leave.user.leave_details
          leave_details.each do |l|
            if l.assign_date.year == Time.zone.now.year
              temp_var = l.available_leaves
              unpaid = l.unpaid_leave
              temp_var.each do |k, v|
                hold_var = v.to_f
              if hold_var <= 0
              unpaid.each do |key, value|
                  hold_value = value.to_f
                  @addition_var = hold_value + num_day
                end
                  l.unpaid_leave = {@leave.id => @addition_var}
p "var val is,"
p l
                  if l.save
                  UserMailer.extra_leave(@leave).deliver
end
		                    else
              tmp_num = l.available_leaves[@leave.leave_type.id.to_s].to_f
              tmp_num = tmp_num - @leave.number_of_days 
              l.available_leaves[@leave.leave_type.id.to_s] = tmp_num
              l.save
	      format.html { redirect_to leaves_path, notice: 'Leave is successfully approved.' }          
	      format.js
              end
                end
            end
          end
	  
        else
          format.html { render   "approve.js" }
          format.json { render json: @leave.errors, status: :unprocessable_entity }
	  format.js
	end
      end
    end
  end

  def rejectStatus
    @leave = Leave.find(params[:id])
    if request.put?
      available_leaves = available_leaves(@leave.user)
      @leave.access_params(params[:leave], available_leaves)
      @leave.status = "Rejected"
      p @leave.reject_reason = params[:leave][:reject_reason]
      p params[:leave][:reject_reason]
      respond_to do |format|
        if @leave.update_attributes(params[:leave])
          UserMailer.rejectStatusLeave(@leave, current_user).deliver
          format.html { redirect_to leaves_path, notice: 'Leave is successfully rejected.' }     
            format.js
        else
          format.html { render  "rejectStatus.js"}
	  format.xml { render json: @leave.errors, status: :unprocessable_entity }
	  format.js
        end
      end
    end
  end

  def destroy 
    @leave = Leave.find(params[:id])
    user = User.find(current_user)
    if current_user.roles == "Admin" && @leave.status == "Approved"
      @leave.user.leave_details.each do |l|
        if l.assign_date.year == Date.today.year
          tmp_num = l.available_leaves[@leave.leave_type_id.to_s].to_f
          tmp_num = tmp_num + @leave.number_of_days
          l.available_leaves[@leave.leave_type_id.to_s] = tmp_num
          l.save
          @leave.destroy
          redirect_to leaves_url, notice: 'Applied leave is deleted successfully.'
        end
      end
    elsif current_user.roles == 'Admin'
      @leave.destroy
      UserMailer.cansleLeave(@leave, user).deliver
      redirect_to leaves_url, notice: 'Applied leave is deleted successfully.'
    else
      if @leave.status == 'Pending'
        @leave.destroy
        user_r = current_organization.users.where(:roles => 'Admin').collect(&:email)
        UserMailer.destroyLeave(user, user_r).deliver
	        redirect_to leaves_url, notice: 'Your applied leave is deleted successfully.'
      else
        redirect_to leaves_path, notice: 'You cannot cancel the leave.'
      end
    end  
  end

  private
  def available_leaves(user)
    available_leaves = nil
    if user.leave_details != nil
      user.leave_details.each do |l|
        if l.assign_date.year == Date.today.year
          available_leaves = l.available_leaves
        end
          end
    end
    return available_leaves
    end

end
