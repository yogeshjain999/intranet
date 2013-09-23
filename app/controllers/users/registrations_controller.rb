class Users::RegistrationsController < Devise::RegistrationsController
  
  def edit
    @user.build_private_profile if @user.private_profile.nil?
    @user.build_public_profile if @user.public_profile.nil?
    2.times{@user.private_profile.relative_details.build} if @user.private_profile.relative_details.empty?

    if @user.private_profile.addresses.empty?
      ADDRESSES.each do |a| 
        @user.private_profile.addresses.build({:type_of_address => a})
      end
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
    @user = User.find(current_user.id)
    if @user.update_attributes(devise_parameter_sanitizer.for(:account_update))
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      flash.notice = 'Sent for verification Succesfully'
      @hr = User.where(role: User::ROLES[2]).first
      #UserMailer.verification(@hr, @user).deliver
      redirect_to edit_user_registration_path
    else
      render "edit"
    end
  end
end
