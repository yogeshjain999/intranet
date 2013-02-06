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
      can :update,  Profile, :user_id => @user.id 
      can [:create, :update], Leave, :user_id => @user.id 
      can :approve_leave, Leave
      cannot :approve_leave, Leave, :user_id => @user.id   
      can :reject_leave, Leave
      cannot :reject_leave, Leave, :user_id => @user.id 
      can :read, Leave
    elsif user.has_role?('Manager')
      cannot [:create, :update, :destroy], LeaveType    
      cannot :create, User
      can :approve_leave, Leave
      cannot :approve_leave, Leave, :user_id => @user.id 
      can :reject_leave, Leave
      cannot :reject_leave, Leave, :user_id => @user.id
      can :read, Leave, :user_id => @user.id
      can :read, Leave, :user_id.in => @user.employees.map(&:id)
      can :update, Profile, :user_id => @user.id 
      can [:create, :update], Leave, :user_id => @user.id 
    elsif user.has_role?('Employee') 
      cannot [:create, :update, :destroy], LeaveType    
      cannot :create, User
      cannot :approve_leave, Leave
      cannot :reject_leave, Leave
      can :update, Profile, :user_id => @user.id 
      can [:create, :read, :update], Leave, :user_id => @user.id 
    end
  end
end
 