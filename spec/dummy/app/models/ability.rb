# frozen_string_literal: true
class Ability
  include CanCan::Ability
  include PaidUp::Ability

  def initialize(user)
    user ||= User.new # anonymous user (not logged in)

    # Rails Application's initialization could go here.

    initialize_paid_up(user)
  end
end
