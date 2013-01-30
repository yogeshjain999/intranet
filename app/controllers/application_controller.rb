class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    if resource && resource.sign_in_count == 1
p resource
     edit_user_path(resource)
    else
      super
    end
  end

  def current_organization
    return @current_organization if @current_organization.present?
    @current_organization = Organization.find_by_slug!( extract_subdomain )
    # make sure we can only access the current users account!
    if @current_organization.present? && current_user && @current_organization != current_user.organization
      sign_out_and_redirect(current_user)
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
