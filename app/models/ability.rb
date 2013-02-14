class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
      cannot  :update, Leave
    elsif user.has_role?('HR')
      cannot [:create, :update, :destroy ], LeaveType
      cannot :create, User      
      cannot :assign_leave, LeaveDetail 
      can :update,  Profile, :user_id => @user.id 
      can [:create, :update, :destroy], Leave, :user_id => @user.id 
      can [:approve_leave, :reject_leave, :read], Leave
      cannot [:reject_leave, :approve_leave], Leave, :user_id => @user.id 
    elsif user.has_role?('Manager')
      cannot [:create, :update, :destroy], LeaveType    
      cannot :create, User
      cannot :assign_leave, LeaveDetail 
      can [:approve_leave, :reject_leave], Leave
      cannot [:approve_leave, :reject_leave], Leave, :user_id => @user.id 
      can :read, Leave, :user_id.in => @user.employees.map(&:id)
      can :update, Profile, :user_id => @user.id 
      can [:create, :read, :update, :destroy], Leave, :user_id => @user.id 
    elsif user.has_role?('Employee') 
      cannot [:create, :update, :destroy], LeaveType    
      cannot :create, User
      cannot :assign_leave, LeaveDetail 
      cannot [:approve_leave, :reject_leave], Leave
      can :update, Profile, :user_id => @user.id 
      can [:create, :read, :update, :destroy ], Leave, :user_id => @user.id 
    end
  end
end
 