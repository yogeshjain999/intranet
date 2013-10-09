class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:edit, :update, :show, :public_profile, :private_profile]
  before_action :load_profiles, only: [:public_profile, :private_profile, :update]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if params[:user][:employee_detail_attributes].present?
      @user.employee_detail.update_attributes(params[:user][:employee_detail_attributes].permit(:employee_id, :notification_emails))
    elsif params[:user][:attachments_attributes].present?
      logger.info '-------------------'
      @user.update(params[:user].permit!)
      @user.save(validate: false)
    else
      @user.set(params.require(:user).permit(:status))
    end
    logger.info @user.errors.full_messages
    redirect_to users_path
    flash.notice = 'Profile status updated Succesfully'
  end

  def show
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
      if user_profile.update_attributes(params.require(profile).permit!)
        flash.notice = 'Profile Updated Succesfully'
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
      @user.build_public_profile
      @user.build_private_profile
      2.times {@user.private_profile.contact_persons.build}
      ADDRESSES.each{|a| @user.private_profile.addresses.build({:type_of_address => a}).save}

      if @user.save
        flash.notice = 'Invitation sent Succesfully'
        UserMailer.delay.invitation(current_user, @user)
        redirect_to root_path
      else
        render 'invite_user'
      end
    end
  end

  private
  def load_user
    @user = User.find(params[:id])
  end

  def load_profiles
    @public_profile = @user.public_profile.nil? ? @user.build_public_profile : @user.public_profile   
    @private_profile = @user.private_profile.nil? ? @user.build_private_profile : @user.private_profile
    @user.employee_detail.nil? ? @user.build_employee_detail : @user.employee_detail
    2.times {@user.attachments.build} if @user.attachments.empty?
  end
end
