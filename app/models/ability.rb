class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @current_organization = @user.organization if @user.respond_to?(:organization)

    if user.has_role?('Admin')
      can :manage, :all
      cannot [:edit, :create], Leave
      cannot :leavessummary, User
    elsif user.has_role?('HR')
      can [:profile, :update, :leavessummary], User, :id => @user.id   
      can [:create, :update, :destroy], Leave, :user_id => @user.id 
      can [:approve, :rejectStatus], Leave, :user_id.in => User.in(:roles => ["Manager","Employee"]).map(&:id)
      can :read, Leave
      can [:leave_summary_for_roles, :leave_summary_on_roles], User
    elsif user.has_role?('Manager')
      can [:approve, :rejectStatus, :read], Leave, :user_id.in => @user.employees.map(&:id)
      can [:profile, :update, :leavessummary], User, :id => @user.id   
      can [:create, :read, :update, :destroy], Leave, :user_id => @user.id 
      can [:leave_summary_for_roles, :leave_summary_on_roles], User
    elsif user.has_role?('Employee') 
      can [:profile, :update, :leavessummary], User, :id => @user.id   
      can [:create, :read, :update, :destroy ], Leave, :user_id => @user.id 
    end
  end
end
 