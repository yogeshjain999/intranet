class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:edit, :update, :show, :public_profile, :private_profile]
  before_action :load_profiles, only: [:public_profile, :private_profile, :update, :edit]
  before_action :build_addresses, only: [:public_profile, :private_profile, :edit]

  def index
    @users = User.employees
  end


  def update
    @user.attributes =  user_params
    if @user.save
      flash.notice = 'Profile status updated Succesfully'
      UserMailer.delay.verification(@user.id)
    else
      flash[:error] = "Error #{@user.errors.full_messages.join(' ')}"
    end
    redirect_to public_profile_user_path(@user)
  end

  def public_profile
    profile = params.has_key?("private_profile") ? "private_profile" : "public_profile"
    update_profile(profile)
  end

  def private_profile
    profile = params.has_key?("private_profile") ? "private_profile" : "public_profile"
    update_profile(profile)
  end
  
  def update_profile(profile)
    user_profile = (profile == "private_profile") ? @private_profile : @public_profile
    if request.put?
      #Need to change these permit only permit attributes which should be updated by user
      #In our application there are some attributes like joining date which will be only 
      #updated by hr of company
      if user_profile.update_attributes(params.require(profile).permit!)
        flash.notice = 'Profile Updated Succesfully'
        UserMailer.delay.verification(@user.id)
        redirect_to public_profile_user_path(@user)
      else
        render "public_profile"
      end
    end
  end

  def invite_user
    if request.get?
      @user = User.new 
    else
      @user = User.new(params[:user].permit(:email, :role))
      @user.password = Devise.friendly_token[0,20]
      if @user.save
        flash.notice = 'Invitation sent Succesfully'
        UserMailer.delay.invitation(current_user.id, @user.id)
        redirect_to root_path
      else
        render 'invite_user'
      end
    end
  end

  def download_document
    document = Attachment.where(id: params[:id]).first.document
    document_type = MIME::Types.type_for(document.url).first.content_type
    send_file document.path, filename: document.model.name, type: "#{document_type}"
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
  
  def user_params
    safe_params = [] 
    if params[:user][:employee_detail_attributes].present?
      params["user"]["employee_detail_attributes"]["notification_emails"].reject!(&:blank?)
      safe_params = [ employee_detail_attributes: [:id, :employee_id, :notification_emails => [] ]]
    elsif params[:user][:attachments_attributes].present?
      safe_params = [attachments_attributes: [:id, :name, :document, :_destroy]] 
    else
      safe_params = [:status]
    end
    params.require(:user).permit(*safe_params)
  end

  def load_profiles
    @public_profile = @user.public_profile.nil? ? @user.build_public_profile : @user.public_profile   
    @private_profile = @user.private_profile.nil? ? @user.build_private_profile : @user.private_profile
    @user.employee_detail.nil? ? @user.build_employee_detail : @user.employee_detail
    @user.attachments.build if @user.attachments.empty? and not (params[:user] && params[:user][:attachments_attributes]).present?
  end

  def build_addresses
    if request.get?
      ADDRESSES.each{|a| @user.private_profile.addresses.build({:type_of_address => a})} if @user.private_profile.addresses.empty?
      # need atleast two contact persons details
      2.times {@user.private_profile.contact_persons.build} if @user.private_profile.contact_persons.empty?
    end
  end
end
