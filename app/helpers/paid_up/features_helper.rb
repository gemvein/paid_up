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
  end
end
