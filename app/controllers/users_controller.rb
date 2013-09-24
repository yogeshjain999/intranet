class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit!)
      redirect_to edit_user_path(@user)
    else
      render "edit"
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def invite_user
    if request.get?
      @user = User.new
      @user.bluid_public_profile
      @user.build_private_profile
    else
      @user = User.new(params[:user].permit(:email, :role))
      @user.password = Devise.friendly_token[0,20]
      if @user.save
        flash.notice = 'Invitation sent Succesfully'
        UserMailer.invitation(current_user, @user).deliver
        redirect_to root_path
      else
        render 'invite_user'
      end
    end
  end
end
