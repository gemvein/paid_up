module PaidUp
  module PlansHelper
    include ::ActionView::Helpers::NumberHelper

    def plan_charge_human(plan)
      number_to_currency(plan.charge) + '/' + plan_period_phrase(plan)
    end

    def plan_period_phrase(plan)
      period_phrase = ''
      if plan.interval_count > 1
        period_phrase += plan.interval_count.to_s
        period_phrase += ' '
      end
      period_phrase + plan.interval.capitalize
    end

  end
end