class UsersController  < ApplicationController
  before_filter :authenticate_inviter!, :only => [:new, :create]


  def index
    @users = current_organization.users.ne(email: current_user.email)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
    authorize! :read, @user
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    @user.build_profile if @user.profile.nil?
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def assignleaves
    @user = User.find(params[:user_id])
    @leave_types = current_organization.leave_types.all
    if request.get?
      if @user.leave_details[0].nil?
        @user.leave_details.build(:assign_date => Time.zone.now.to_s)
        @assign_leaves = calculate_leaves
      else
        @assign_leaves = @user.leave_details[0].assign_leaves
      end
    elsif request.post?
      @user.leave_details.build if @user.leave_details[0].nil?
      @user.leave_details[0].assign_date = params[:date]
      @user.leave_details[0].assign_leaves = params[:assign_leaves]
      @user.leave_details[0].available_leaves = params[:assign_leaves]
@user.leave_details[0].save
        redirect_to addleaves_path
    end
 end

  def profile
    @user = User.find(params[:user_id])
    if request.post?
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to profile_path(@user), notice: 'Profile was successfully updated!'  }
        else
          format.html { render action: "profile" }
        end
      end
    end
  end

  def reinvite
    @user = User.find(params[:user_id])
    @user.invite!(current_user)
  end

def leavessummary
    @leave_details = current_user.leave_details
    @leave_types = current_organization.leave_types.all
    respond_to do |format|
      format.html # leavessummary.html.erb
      format.json { render json: @leave_details}
    end
  end

private
  def calculate_leaves
    start_date = Time.zone.now.to_date
    end_date = Time.zone.now.end_of_year.to_date
    months = end_date.month - start_date.month
    assign_leaves = {}
    @leave_types.each do |lt|
      num_leaves = (lt.max_no_of_leaves/12.0*months).round(0)
      assign_leaves[lt.id] = num_leaves
    end
    return assign_leaves
  end

end

