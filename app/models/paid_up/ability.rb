# frozen_string_literal: true

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

    def enable_read(model)
      can :index, model
      can :show, model, &:enabled?
    end

    def enable_rows(model, allowed, remaining)
      if allowed.positive?
        can :own, model
        cannot :create, model
        can(%i(create new), model) if remaining.positive?
      else
        cannot %i(delete update own create), model
      end
    end

    def enable_table_rows(user, feature)
      model = feature.feature_model
      enable_read(model)
      return if user.new_record?
      slug = feature.slug
      table_setting = user.table_setting(slug)
      allowed = table_setting.rows_allowed
      remaining = table_setting.rows_remaining
      can :manage, model, user: user if allowed.positive?
      enable_rows(model, allowed, remaining)
    end

    def enable_rolify_rows(user, feature)
      model = feature.feature_model
      enable_read(model)
      return if user.new_record?
      slug = feature.slug
      rolify_setting = user.rolify_setting(slug)
      allowed = rolify_setting.rows_allowed
      remaining = rolify_setting.rows_remaining
      if allowed.positive?
        can :manage, model, roles: { name: 'owner', users: { id: user.id } }
      end
      enable_rows(model, allowed, remaining)
    end

    def enable_boolean(user, feature)
      slug = feature.slug
      can :use, slug.to_sym if user.plan.feature_setting slug
    end
  end
end
