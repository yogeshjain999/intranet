class UsersController  < ApplicationController
  before_filter :authenticate_inviter!, :only => [:new, :create]
  load_and_authorize_resource 
  skip_authorize_resource :only => :index

  def index
    @users = current_organization.users.ne(email: current_user.email).page(params[:page])
    Kaminari.paginate_array(@users).page(params[:page])
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
@user.update_attributes(params[:user_roles])

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
        @user.leave_details.build(:assign_date => Date.today)
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
  def chengeroles
    @user = User.find(params[:user_id])
      if request.post?
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to users_path, notice: 'Role has been changed !'  }
    end
     end
    end
    end
  def chengemanager
        @user = User.find(params[:user_id])
      if request.post?
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to users_path, notice: 'Manager has been changed !'  }
    end
     end
    end
    end

  def profile
    @user = User.find(params[:user_id])
    if request.post?
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to profile_path(@user), notice: 'Profile was successfully updated!'  }
        else
          format.html { render action: "edit" }
	  format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def reinvite
    @user = User.find(params[:user_id])
    @user.invite!(current_user)
  end

def leavessummary  
    @leave_details = current_user.leave_details.all
p @leave_details 
    @leave_types = current_organization.leave_types.all
  end

  def upload_csv     
    @organization = Organization.find(params[:organization_id])
    respond_to do |format|
       if request.put?
         if @organization.update_attributes(params[:organization]) 
            invite_users
            format.html{ render "upload"}	    
         else
           format.html {render action: "upload_csv"}
	 end
       else
          format.html {render action: "upload_csv"}
      end
    end
end

  def invite_users
    headers = {}
    @invited_users = []
    CSV.foreach(current_organization.csv_attachment.path) do |row|
      invite_params = {}
      if headers.length ==0
        # First row is known as headers.
        # Fill the hash with the headers
        # Each header value would be key
        row.each do |k|
          headers[k] = ""
        end
      else
        # Fill the hash with row values for each key
        index = 0
        headers.keys.each do |k|
          invite_params.store(k, row[index])
          index = index + 1

        end
        if invite_params["manager"] != nil
          invite_params["manager"] = User.find_by(:email => invite_params["manager"]).id
        end
        invite_params["organization_id"] = current_organization.id
        user = User.invite!(invite_params, current_user)
        if user.errors.messages == {}
        @leave_types = current_organization.leave_types.all
        assign_leaves =calculate_leaves
        user.leave_details.build if user.leave_details[0].nil?
        user.leave_details[0].assign_date = Date.today
        user.leave_details[0].assign_leaves = assign_leaves
        user.leave_details[0].available_leaves = assign_leaves
        user.leave_details[0].save
        end
        @invited_users.push(user)
      end
    end
  end

  def managers
    organization = Organization.find_by(:name => request.subdomain)
    users = organization.users.where(:roles => "Manager")
    responseText = nil
    users.each do |u|
      if responseText == nil
        responseText = u.email
      else
        responseText = responseText + "," + u.email
      end
    end
    render :text => responseText, :content_type => "text/plain"
    end

    def leave_summary_on_roles
      @user = User.find(params[:user_id])
      @leave_details = @user.leave_details.all
      @leave_types = current_organization.leave_types.all
    end  

end

