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
        if plan.feature_setting(feature.slug)
          icon 'ok'
        else
          icon 'remove'
        end
      elsif plan.feature_unlimited?(feature.slug)
        :unlimited.l
      else
        plan.feature_setting(feature.slug)
      end
    end

    def features_table(options = {})
      should_add_buttons = options.delete(:should_add_buttons) || true
      highlight = options.delete(:highlight)
      only = options.delete(:only)
      except = options.delete(:except)

      plans = PaidUp::Plan.subscribable
      plans = plans.where(id: only) if only.present?
      plans = plans.where.not(id: except) if except.present?

      features = PaidUp::Feature.all

      render(
        partial: 'paid_up/features/table',
        locals: {
          should_add_buttons: should_add_buttons,
          plans: plans,
          features: features,
          highlight_plan: highlight,
          html_options: options
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
