# CanCanCan Ability class
class Ability
  include CanCan::Ability
  include PaidUp::Ability

  def initialize(user)
    user ||= User.new # anonymous user (not logged in)

    # Rails Application's initialization could go here.
    # can :manage, Group, user: user

    initialize_paid_up(user)
  end
end
