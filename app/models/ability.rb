class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? 'Super Admin'
      can :manage, :all
    elsif user.role? 'Admin'
      can :invite_user, User
    elsif user.role? 'HR'
      can :public_profile, User
      can :private_profile, User
    else
      can :show, User
    end
  end
end
