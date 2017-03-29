# frozen_string_literal: true

module PaidUp
  # Class for 'rolify_rows' feature setting type
  class RolifyFeatureSettingType < FeatureSettingType
    def rows
      scope.with_role(:owner, user)
    end
  end
end
