class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:edit, :update, :show, :public_profile, :private_profile]
  before_action :load_profiles, only: [:public_profile, :private_profile]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update_attributes(params.require(:user).permit!)
      redirect_to edit_user_path(@user)
    else
      render "edit"
    end
  end
  
  def show
  end

  def public_profile
    if request.put?
      if @public_profile.update_attributes(params.require(:public_profile).permit!)
        redirect_to public_profile_user_path(@user)
      else
        render "public_profile"
      end
    end
  end

  def private_profile
    if request.put?
      if @private_profile.update_attributes(params.require(:private_profile).permit!)
        redirect_to private_profile_user_path(@user)
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
      ADDRESSES.each{|a| @user.private_profile.addresses.build({:type_of_address => a})}

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
  end
end
