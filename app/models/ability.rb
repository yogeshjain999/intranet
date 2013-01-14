class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
    elsif user.has_role?('HR')
      can [:create, :update], [ Profile, Leave]
      cannot :update, Leave, :user_id => @user.id   
    elsif user.has_role?('Manager')
      can [:create, :update],  [ Profile, Leave]
      cannot :update, Leave if user.has_role("HR")?   
      cannot :update, Leave, :user_id => @user.id
    elsif user.has_role?('Employee') 
      can [:create, :update], Profile 
      can :create, Leave
    end
  end
end
 