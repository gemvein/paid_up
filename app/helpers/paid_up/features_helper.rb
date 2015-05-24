module PaidUp
  module FeaturesHelper
    include PaidUp::PaidUpHelper

    def features_dl(plan)
      data = {}
      features = PaidUp::Feature.all

      for feature in features
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
      features = PaidUp::Feature.all

      if !options[:should_add_buttons].nil?
        should_add_buttons = options[:should_add_buttons]
        options.delete(:should_add_buttons)
      else
        should_add_buttons = true
      end

      plans = PaidUp::Plan.subscribable
      if options[:only].present?
        plans = plans.where('id IN (?)', options[:only])
        options.delete(:only)
      end
      if options[:except].present?
        plans = plans.where('NOT ( id IN (?) )', options[:except])
        options.delete(:except)
      end

      if options[:highlight].present?
        highlight_plan = options[:highlight]
        options.delete(:highlight)
      else
        highlight_plan = nil
      end

      render(partial: 'paid_up/features/table', locals: { should_add_buttons: should_add_buttons, plans: plans, features: features, highlight_plan: highlight_plan, html_options: options})
    end

    def feature_abilities_table(options = {})
      features = PaidUp::Feature.all
      render(partial: 'paid_up/features/abilities_table', locals: { features: features, html_options: options})
    end
  end
end