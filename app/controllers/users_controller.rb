class UsersController < ApplicationController

  def invite_user
    if request.get?
      @user = User.new
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
