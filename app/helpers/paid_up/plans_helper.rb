module PaidUp
  module PlansHelper
    include ::ActionView::Helpers::NumberHelper

    def plan_charge_human(plan)
      plan.money.format + '/' + plan_period_phrase(plan)
    end

    def plan_period_phrase(plan)
      period_phrase = ''
      if plan.interval_count > 1
        period_phrase += plan.interval_count.to_s
        period_phrase += ' '
      end
      period_phrase + plan.interval.capitalize
    end

    def plan_button(plan, text = nil, html_options = {})
      data = {}
      css_class = 'btn '
      disabled_state = false
      link = paid_up.new_plan_subscription_path(plan)
      text ||= :subscribe.l
      if @current_subscriber.can_upgrade_to? plan
        icon_class = 'arrow-up'
        css_class += 'btn-success'
      elsif @current_subscriber.can_downgrade_to? plan
        icon_class = 'arrow-down'
        css_class += 'btn-danger'
        data[:confirm] = :are_you_sure.l
      elsif @current_subscriber.is_subscribed_to? plan
        icon_class = 'ok'
        css_class += 'btn-disabled'
        disabled_state = true
        link = '#'
        text = :already_subscribed.l
      else # Plans are equal in sort_order
        icon_class = 'arrow-right'
        css_class += 'btn-info'
      end
      html_options[:method] ||= :get
      html_options[:disabled] ||= disabled_state
      icon_button_to css_class, icon_class, text, link, html_options
    end

  end
end