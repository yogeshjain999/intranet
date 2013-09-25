class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user
      if user.persisted?
        flash.notice = "Signed in Through Google!"
        sign_in_and_redirect user
      else
        session["devise.user_attributes"] = user.attributes
        flash.notice = "You are almost Done! Please provide a password to finish setting up your account"
        redirect_to new_user_registration_url
      end
    else
      flash.notice = "You are not authorized to sign in!!! Before you leave this page, Please logout from your google account."
      redirect_to new_user_session_path
    end
  end
end
