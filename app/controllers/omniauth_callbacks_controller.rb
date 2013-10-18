class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user
      if user.persisted?
        flash.notice = "Signed in Successfully!"
        sign_in_and_redirect user
      else
        session["devise.user_attributes"] = user.attributes
        flash.notice = "Contact Josh Software Admin for valid invitation request"
        redirect_to root_url
      end
    else
      flash.notice = "You are not authorized to sign in!!! Before you leave this page, Please logout from your google account."
      redirect_to new_user_session_path
    end
  end
end
