class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # anonymous user (not logged in)

    # Rails Application's initialization could go here.

    initialize_paid_up(user)
  end

  def initialize_paid_up(user)
    features = PaidUp::Feature.all

    for feature in features

      case feature.setting_type
        when 'table_rows'
          model = feature.name.classify.constantize
          if user.table_rows_allowed(feature.name) > 0 || user.table_rows_allowed(feature.name) == -1
            can :manage, model, :user => user
            can :own, model
            unless user.table_rows_remaining(feature.name) > 0
              cannot :create, model
            end
          end
          can :read, model
        when 'boolean'
          if user.plan.feature_setting feature.id
            can :use, feature.name.to_sym
          end
        else
          raise(:unknown_feature_type.l)
      end
    end
  end
end
