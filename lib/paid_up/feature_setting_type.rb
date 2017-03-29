# frozen_string_literal: true

# PaidUp module
module PaidUp
  # Feature Setting Type Class: Not an ActiveRecord object.
  class FeatureSettingType
    include ActiveModel::Model
    include ActiveModel::AttributeMethods

    attr_accessor :name, :user
    delegate :plan, to: :user

    def rows_unlimited?
      rows_allowed == PaidUp::Unlimited.to_i
    end

    def rows_remaining
      rows_allowed - rows_count
    end

    def rows_allowed
      plan.feature_setting name
    end

    def rows
      scope.where(user: user)
    end

    def ids
      rows.ids
    end

    def rows_count
      rows.size
    end

    def model
      name.classify.constantize
    end

    def scope
      model.paid_for_scope
    end
  end
end
