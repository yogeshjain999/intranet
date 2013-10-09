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
    elsif user.role? 'HR'
      can [:public_profile, :private_profile], User
      can :edit, User
    else
      can :read, User
    end
  end
end
