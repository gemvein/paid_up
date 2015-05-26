module PaidUp
  module Ability
    include CanCan::Ability

    def initialize_paid_up(user)
      features = PaidUp::Feature.all
      for feature in features
        case feature.setting_type
          when 'table_rows'
            can :read, feature.feature_model
            if user.table_rows_allowed(feature.slug) > 0 || user.table_rows_unlimited?(feature.slug)
              can :manage, feature.feature_model, :user => user
              can :own, feature.feature_model
              unless user.table_rows_remaining(feature.slug) > 0
                cannot :create, feature.feature_model
              end
            else
              cannot :delete, feature.feature_model
              cannot :update, feature.feature_model
              cannot :own, feature.feature_model
              cannot :create, feature.feature_model
            end
          when 'rolify_rows'
            can :read, feature.feature_model
            if user.rolify_rows_allowed(feature.slug) > 0 || user.rolify_rows_unlimited?(feature.slug)
              can :manage, feature.feature_model do |record|
                user.has_role? :owner, record
              end
              can :own, feature.feature_model
              if user.rolify_rows_remaining(feature.slug) > 0
                can :create, feature.feature_model
              else
                cannot :create, feature.feature_model
              end
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
