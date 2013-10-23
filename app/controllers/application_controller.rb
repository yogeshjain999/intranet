class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
=begin
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u| 
      u.permit(:password_confirmation, :role, :email, :password, :first_name, :last_name, :gender, :date_of_birth, :role) 
    end
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me, :password_confirmation, :role) }

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:public_profile_attributes => [:id, :first_name, :last_name, :gender, :mobile_number, :blood_group, :date_of_birth, :photo], :private_profile_attributes => [:id, :pan_number, :passport_number, :qualification, :date_of_joining, :date_of_relieving, :work_experience, :addresses_attributes => [:id, :type_of_address, :flat_or_house_no, :building_or_society_name, :road, :locality, :city, :state, :phone_no], :relative_details_attributes => [:id, :relative, :name, :phone_no]])
    end
  end
=end
end
