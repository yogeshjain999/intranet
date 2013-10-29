class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? 'Super Admin'
      can :manage, :all
    elsif user.role? 'Admin'
      can :invite_user, User
      can :edit, User
      can [:public_profile, :private_profile], User
      can :manage, Project
    elsif user.role? 'HR' 
      can :manage, Project
      can [:public_profile, :private_profile, :edit, :apply_leave], User
      can [:new, :create, :edit, :destroy], LeaveApplication
    elsif user.role? 'Employee'
      can [:public_profile, :private_profile, :apply_leave], User
      can :read, :all
      cannot :manage, Project
    elsif user.role? 'Intern'
      can [:public_profile, :private_profile, :apply_leave], User
      can :read, :all
      cannot :manage, Project
    else
      can :read, :all
      #can [:public_profile, :private_profile, :edit, :apply_leave], User
      can [:new, :create, :edit, :destroy], LeaveApplication do
        #user.date
      end
    end
  end
end
