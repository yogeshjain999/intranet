class Users::RegistrationsController < Devise::RegistrationsController
=begin  
  def edit
    #@user.build_private_profile if @user.private_profile.nil?
    #@user.build_public_profile if @user.public_profile.nil?
    @user = User.find(params[:id])
    @public_profile = @user.public_profile 
    @private_profile = @user.private_profile
    2.times {@user.private_profile.contact_persons.build} if @user.private_profile.contact_persons.empty?

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
    @user = User.find(params[:id])
    if @user.update_attributes(devise_parameter_sanitizer.for(:account_update))
      @user.update_attributes(status: STATUS[1])
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      flash.notice = 'Sent for verification Succesfully'
      @hr = User.where(role: User::ROLES[2]).first
      UserMailer.delay.verification(@hr, @user)
      redirect_to user_path 
    else
      render "public_profile"
    end
  end
=end
end
