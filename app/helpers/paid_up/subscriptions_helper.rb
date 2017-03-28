# frozen_string_literal: true
module PaidUp
  # PaidUp Subscriptions Helper
  module SubscriptionsHelper
    include PaidUp::PaidUpHelper

    def subscription_dl(subscription)
      data = {}

      data[:status.l] = subscription.status

      period_start = subscription.current_period_start
      period_end = subscription.current_period_end

      if period_start || period_end
        data[:paid_thru.l] = date_range(period_start, period_end)
      end

      trial_start = subscription.trial_start
      trial_end = subscription.trial_end

      if trial_start || trial_end
        data[:trial_period.l] = date_range(trial_start, trial_end)
      end

      dl data
    end
  end
end
