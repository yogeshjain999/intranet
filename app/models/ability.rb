class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
    elsif user.has_role?('HR')
      cannot? :create, LeaveType    
    elsif user.has_role?('Manager')
      cannot? :create, LeaveType   
    elsif user.has_role?('Employee') 
      cannot? :create, LeaveType   

    end
  end
end
 