class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
    elsif user.has_role?('HR')
    elsif user.has_role?('Manager')
    elsif user.has_role?('Employee') 
    end
  end
end
