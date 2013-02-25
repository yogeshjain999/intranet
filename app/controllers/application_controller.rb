class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protect_from_forgery

  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    if resource && resource.sign_in_count == 1
p resource
#     edit_user_path(resource)
#    else
#      leaves_path
      edit_user_path(resource)
    elseif resource
      leaves_path
    else 
      super
    end
  end

  def after_invite_path_for(resource)
    addleaves_path
  end

  def current_organization
    if extract_subdomain != nil
      @current_organization = Organization.find_by_slug!( extract_subdomain )
      # make sure we can only access the current users account!
      if @current_organization != nil && current_user != nil && current_user.organization == @current_organization
        return @current_organization
      else
        sign_out
        redirect_to root_path, notice: "Your not a member of this organization"
      end
    else
      redirect_to root_path, notice: "Your not a member of this organization"
    end
  end
  helper_method :current_organization

	private

  def extract_subdomain
    subdomain = request.subdomains.first
    if subdomain == "www" 
      subdomain = request.subdomains.last
    end
    return subdomain
  end
end
