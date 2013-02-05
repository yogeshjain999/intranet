class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
    elsif user.has_role?('HR')
      cannot [:create, :update, :destroy ], LeaveType
      cannot :create, User
      cannot :approve_leave, Leave, :user_id => @user.id   
      can :update,  Profile, :user_id => @user.id 
      can :create, Leave 
      #can :approve_leave, Leave
      can :read, Leave
    elsif user.has_role?('Manager')
      cannot [:create, :update, :destroy], LeaveType    
      cannot :create, User
      cannot :approve_leave, Leave, :user_id => @user.id 
      can :read, Leave, :user_id => @user.manager
      can :update, Profile, :user_id => @user.id 
      can :create, Leave 
      can :approve_leave, Leave
    elsif user.has_role?('Employee') 
      cannot [:create, :update, :destroy], LeaveType    
      cannot :create, User
      cannot :approve_leave, Leave
      can :update, Profile, :user_id => @user.id 
      can :create, Leave 
      can :read, Leave, :user_id => @user.id
    end
  end
end
 