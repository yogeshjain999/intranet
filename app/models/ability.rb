class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? 'Super Admin'
      can :manage, :all
    elsif user.role? 'Admin'
      can :invite_user, User
    end
  end
end
