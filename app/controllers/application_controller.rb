class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|

redirect_to root_url, :alert => exception.message
  end

  protect_from_forgery :except => :managers
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, :only => :managers

  def after_sign_in_path_for(resource)
    if current_organization != nil
      if resource && resource.sign_in_count == 1
        edit_user_path(resource)
      elsif resource
          leaves_path
      end
    end
  end

  def after_invite_path_for(resource)
    user = resource
p "params"
p params
l_t = params[:leave_type]
p "the new var will be:"
pay = params[:pay_role]
p "pay role will be"
p params[:user][:pay_role]
  if params[:user][:pay_role] == "1"
    @leave_types = current_organization.leave_types.where(:id => l_t)
p "first will show var in if"
p @leave_types
  else
    @leave_types = current_organization.leave_types.all
p "else part is,"
p @leave_types
      end

    assign_leaves =calculate_leaves
    user.leave_details.build if user.leave_details[0].nil?
    user.leave_details[0].assign_date = Date.today
    user.leave_details[0].assign_leaves = assign_leaves
    user.leave_details[0].available_leaves = assign_leaves
    user.leave_details[0].save
    users_path
  end

  def calculate_leaves
    start_date = Time.zone.now.to_date
    end_date = Time.zone.now.end_of_year.to_date
    months = end_date.month - start_date.month
    assign_leaves = {}
    @leave_types.each do |lt|
      if lt.auto_increament == true
        num_leaves = lt.number_of_leaves
      else
      num_leaves = (lt.max_no_of_leaves/12.0*months).round(0)
      end
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
        return nil
      end
    else
      return nil
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

  def authenticate_inviter!
    unless current_user.roles == 'Admin'
      redirect_to root_url, :alert => "You are not authorized to access this page."
    end
    super
  end


end
	
