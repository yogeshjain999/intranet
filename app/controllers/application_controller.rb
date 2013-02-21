class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protect_from_forgery

  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    if resource && resource.sign_in_count == 1
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
p extract_subdomain
    @current_organization = Organization.find_by_slug!( extract_subdomain )
p "Priting the organization" + @current_organization
    # make sure we can only access the current users account!
    if @current_organization.present? && current_user && @current_organization != current_user.organization
      sign_out_and_redirect(home_path, notice: "")
    end
    @current_organization
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
