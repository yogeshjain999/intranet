class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? 'Super Admin'
      can :manage, :all
    elsif user.role? 'Admin'
      admin_abilities
    elsif user.role? 'HR'
      hr_abilities
    elsif user.role? 'Finance'
      can [:public_profile, :private_profile, :edit, :apply_leave], User 
    elsif user.role? 'Manager'
      can :manage, Project
      can [:public_profile, :private_profile, :apply_leave], User 
    elsif user.role? 'Employee'
      can [:public_profile, :private_profile, :apply_leave], User
      can [:index, :download_document], Attachment
      cannot :manage, Project
    elsif user.role? 'Intern'
      can [:public_profile, :private_profile, :apply_leave], User
      can :read, :all
      cannot :manage, Project
    end
  end

  def admin_abilities
    can :invite_user, User
    can :edit, User
    can [:public_profile, :private_profile], User
    can :manage, Project
    can :manage, Attachment
  end

  def hr_abilities
    can :manage, Project
    can :invite_user, User
    can [:public_profile, :private_profile, :edit, :apply_leave], User
    can [:new, :create, :edit, :destroy], LeaveApplication
    can :manage, Attachment
  end
end
