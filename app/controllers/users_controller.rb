class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:edit, :update, :show]

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
end
