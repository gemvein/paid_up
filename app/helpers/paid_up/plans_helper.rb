# frozen_string_literal: true

module PaidUp
  # PaidUp Plans Helper
  module PlansHelper
    include ::ActionView::Helpers::NumberHelper

    def plan_charge_human(plan, discount)
      interval = plan_period_phrase(plan)
      if plan.adjust?(discount)
        return amount_per_interval(plan.money.format, interval)
      end
      plan_charge_reduced(
        plan.money.format,
        plan.adjusted_money(discount).format,
        interval
      )
    end

    def plan_button(plan, text = nil, html_options = {})
      atts = plan_button_atts(plan)
      atts[:text] = text if text.present?
      atts[:link] ||= paid_up.new_plan_subscription_path(plan)

      html_options[:method] ||= :get
      html_options[:data] = atts.delete(:data)

      icon_button_to(
        atts[:css_class], atts[:icon_class], atts[:text], atts[:link],
        html_options
      )
    end

    def plan_period_phrase(plan)
      period_phrase = ''
      if plan.interval_count > 1
        period_phrase += plan.interval_count.to_s
        period_phrase += ' '
      end
      period_phrase + plan.interval.capitalize
    end

    private

    def amount_per_interval(amount, interval)
      "#{amount}/#{interval}"
    end

    def plan_charge_reduced(old_money, new_money, interval)
      html = []
      html << content_tag(:s, amount_per_interval(old_money, interval))
      html << content_tag(
        :span, amount_per_interval(new_money, interval), class: 'text-danger'
      )
      html.join(' ')
    end

    # rubocop:disable Metrics/AbcSize
    # This is just this complex.
    def plan_button_atts(plan)
      return anonymous_atts unless user_signed_in?
      return delinquent_atts if current_user.stripe_data.delinquent
      return same_plan_atts if current_user.subscribed_to? plan
      return upgrade_atts if current_user.can_upgrade_to? plan
      return downgrade_atts if current_user.can_downgrade_to? plan
      sidegrade_atts
    end
    # rubocop:enable Metrics/AbcSize

    def anonymous_atts
      { text: :sign_up.l, icon_class: 'arrow-right', css_class: 'success' }
    end

    def delinquent_atts
      { text: :subscribe.l, icon_class: 'arrow-right', css_class: 'info' }
    end

    def upgrade_atts
      { text: :subscribe.l, icon_class: 'arrow-up', css_class: 'success' }
    end

    def downgrade_atts
      { text: :subscribe.l, icon_class: 'arrow-down', css_class: 'danger',
        data: { confirm: :are_you_sure.l } }
    end

    def same_plan_atts
      { text: :already_subscribed.l, icon_class: 'ok', css_class: 'disabled',
        link: '#' }
    end

    def sidegrade_atts
      { text: :subscribe.l, icon_class: 'arrow-right', css_class: 'info' }
    end
  end
end
