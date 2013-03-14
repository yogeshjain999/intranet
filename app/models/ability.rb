class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
      cannot [:edit, :create], Leave
    elsif user.has_role?('HR')
      can [:profile, :update, :leavessummary], User, :id => @user.id   
      can [:create, :update, :destroy], Leave, :user_id => @user.id 
      can [:approve, :rejectStatus, :read], Leave
      cannot [:approve, :rejectStatus], Leave, :user_id => @user.id 
    elsif user.has_role?('Manager')
      can [:approve, :rejectStatus], Leave
      can :read, Leave, :user_id.in => @user.employees.map(&:id)
      can [:profile, :update, :leavessummary], User, :id => @user.id   
      can [:create, :read, :update, :destroy], Leave, :user_id => @user.id 
      cannot [:approve, :rejectStatus], Leave, :user_id => @user.id 
    elsif user.has_role?('Employee') 
      can [:profile, :update, :leavessummary], User, :id => @user.id   
      can [:create, :read, :update, :destroy ], Leave, :user_id => @user.id 
    end
  end
end
 