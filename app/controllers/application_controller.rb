class ApplicationController < ActionController::Base
  protect_from_forgery

#  before_filter :authenticate_user!


  def current_organization
    return @current_organization if @current_organization.present?
    @current_organization = Organization.find_by_slug!( extract_subdomain )

    # make sure we can only access the current users account!
    if @current_organization.present? && current_user && @current_account != current_user.account
      sign_out_and_redirect(current_user)
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
