module PaidUp
  # PaidUp Ability model
  module Ability
    include CanCan::Ability

    def initialize_paid_up(user)
      PaidUp::Feature.all.each do |feature|
        method = "enable_#{feature.setting_type}".to_sym
        send(method, user, feature)
      end
    end

    private

    def enable_table_rows(user, feature)
      slug = feature.slug
      model = feature.feature_model
      can :index, model
      can :show, model, &:enabled
      if user.table_rows_allowed(slug) > 0 ||
         user.table_rows_unlimited?(slug)
        can :manage, model, user: user
        can :own, model
        cannot :create, model
        user.table_rows_remaining(slug) > 0 &&
          can([:create, :new], model)
      else
        cannot [:delete, :update, :own, :create], model
      end
    end

    def enable_rolify_rows(user, feature)
      slug = feature.slug
      model = feature.feature_model
      can :index, model
      can :show, model, &:enabled
      if user.rolify_rows_allowed(slug) > 0 ||
         user.rolify_rows_unlimited?(slug)
        can :manage, model, id: model.with_role(:owner, user).ids
        can :own, model
        cannot :create, model
        user.rolify_rows_remaining(slug) > 0 &&
          can([:create, :new], model)
      else
        cannot [:delete, :update, :own, :create], model
      end
    end

    def enable_boolean(user, feature)
      slug = feature.slug
      can :use, slug.to_sym if user.plan.feature_setting slug
    end
  end
end
