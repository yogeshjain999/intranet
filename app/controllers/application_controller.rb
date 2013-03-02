class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protect_from_forgery

  before_filter :authenticate_user!



  def after_sign_in_path_for(resource)
    if resource && resource.sign_in_count == 1
p resource
     edit_user_path(resource)
    else
      leaves_path
    end
  end

  def after_invite_path_for(resource)
    user = resource
    @leave_types = current_organization.leave_types.all
    assign_leaves =calculate_leaves
    user.leave_details.build if user.leave_details[0].nil?
    user.leave_details[0].assign_date = Date.today
    user.leave_details[0].assign_leaves = assign_leaves
    user.leave_details[0].available_leaves = assign_leaves
    user.leave_details[0].save
    addleaves_path
  end

  def calculate_leaves
    start_date = Time.zone.now.to_date
    end_date = Time.zone.now.end_of_year.to_date
    months = end_date.month - start_date.month
    assign_leaves = {}
    @leave_types.each do |lt|
      num_leaves = (lt.max_no_of_leaves/12.0*months).round(0)
      assign_leaves[lt.id] = num_leaves
    end
    return assign_leaves
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
	