# frozen_string_literal: true

module PaidUp
  # PaidUp Features Helper
  module FeaturesHelper
    include PaidUp::PaidUpHelper

    def features_dl(plan)
      data = {}
      features = PaidUp::Feature.all

      features.each do |feature|
        data[feature.title] = feature_display feature, plan
      end

      dl data
    end

    def feature_display(feature, plan)
      if feature.setting_type == 'boolean'
        icon plan.feature_setting(feature.slug) ? 'ok' : 'remove'
      elsif plan.feature_unlimited?(feature.slug)
        :unlimited.l
      else
        plan.feature_setting(feature.slug)
      end
    end

    def feature_state(feature)
      case feature.setting_type
      when 'boolean'
        boolean_state(feature)
      when 'table_rows'
        setting_state feature, current_user.table_setting(feature.slug)
      when 'rolify_rows'
        setting_state feature, current_user.rolify_setting(feature.slug)
      else
        :error.l
      end
    end

    def features_table(options = {})
      plans = PaidUp::Plan.display options.delete(:only),
                                   options.delete(:except)
      render(
        partial: 'paid_up/features/table',
        locals: {
          highlight_plan: options.delete(:highlight), plans: plans,
          should_add_buttons: options.delete(:should_add_buttons) || true,
          features: PaidUp::Feature.all, html_options: options
        }
      )
    end

    def feature_abilities_table(options = {})
      features = PaidUp::Feature.all
      render(
        partial: 'paid_up/features/abilities_table',
        locals: { features: features, html_options: options }
      )
    end

    private

    def boolean_state(feature)
      render partial: 'paid_up/features/boolean_state', locals: {
        feature: feature
      }
    end

    def setting_state(feature, setting)
      render partial: 'paid_up/features/setting_state', locals: {
        remaining: setting.rows_remaining, used: setting.rows_count,
        allowed: setting.rows_allowed, model: feature.feature_model,
        unlimited: setting.rows_unlimited?
      }
    end
  end
end
