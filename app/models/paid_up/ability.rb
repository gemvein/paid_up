module PaidUp
  # PaidUp Ability model
  module Ability
    include CanCan::Ability

    def initialize_paid_up(user)
      features = PaidUp::Feature.all
      features.each do |feature|
        case feature.setting_type
        when 'table_rows'
          can :index, feature.feature_model
          can :show, feature.feature_model, &:enabled
          if user.table_rows_allowed(feature.slug) > 0 ||
             user.table_rows_unlimited?(feature.slug)
            can :manage, feature.feature_model, user: user
            can :own, feature.feature_model
            cannot :create, feature.feature_model
            user.table_rows_remaining(feature.slug) > 0 &&
              can([:create, :new], feature.feature_model)
          else
            cannot :delete, feature.feature_model
            cannot :update, feature.feature_model
            cannot :own, feature.feature_model
            cannot :create, feature.feature_model
          end
        when 'rolify_rows'
          can :index, feature.feature_model
          can :show, feature.feature_model, &:enabled
          if user.rolify_rows_allowed(feature.slug) > 0 ||
             user.rolify_rows_unlimited?(feature.slug)
            can(
              :manage,
              feature.feature_model,
              id: feature.feature_model.with_role(:owner, user).ids
            )
            can :own, feature.feature_model
            cannot :create, feature.feature_model
            user.rolify_rows_remaining(feature.slug) > 0 &&
              can([:create, :new], feature.feature_model)
          else
            cannot :delete, feature.feature_model
            cannot :update, feature.feature_model
            cannot :own, feature.feature_model
            cannot :create, feature.feature_model
          end
        when 'boolean'
          if user.plan.feature_setting feature.slug
            can :use, feature.slug.to_sym
          end
        else
          raise(:unknown_feature_type.l)
        end
      end
    end
  end
end
