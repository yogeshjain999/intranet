class LeavesController < ApplicationController

  def index    
#    @leave = Leave.all
       @leave = Leave.accessible_by(current_ability)

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @leave }
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
  end

  def create
    @leave = Leave.new(params[:leave])
    @leave.user = current_user

    @leave.number_of_days = (@leave.ends_at - @leave.starts_at).to_i
  user = User.find(current_user)

    @leave.status = "Pending"
    respond_to do |format|
      if @leave.save

  user_role = User.and(:roles => ['Admin', 'HR', 'Manager']).collect(&:email)
   @users = UserMailer.leaveReport(@leave, user, user_role).deliver
        #format.html {redirect_to root_url, notice: 'Your request has been noted'}
        format.html {redirect_to @leave, notice: 'Your request has been noted' }
        format.json {render json: @leave, status: :created}
      end
    end
  end

  def edit
    @leave = Leave.find(params[:id])
  end

  def update
    @leave = Leave.find(params[:id])

    respond_to do |format|
      if @leave.update_attributes(params[:leave])
        format.html { redirect_to @leave, notice: 'Leave is successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @leave = Leave.find(params[:id])
    authorize! :approve_leave, @leave
    @leave.status = "Approved"
    @leave.save
  end

  def rejectStatus
    @leave = Leave.find(params[:id])
    @leave.status = "Rejected"
    @leave.update_attributes(params[:leave])
    redirect_to leaves_path
  end
end
