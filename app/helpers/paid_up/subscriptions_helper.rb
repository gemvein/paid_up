# frozen_string_literal: true

module PaidUp
  # PaidUp Subscriptions Helper
  module SubscriptionsHelper
    include PaidUp::PaidUpHelper

    def subscription_dl(subscription)
      data = {}

      data[:status.l] = subscription.status

      data = add_date_if_set(
        data, :paid_thru, subscription.current_period_start,
        subscription.current_period_end
      )
      data = add_date_if_set(
        data, :trial_period, subscription.trial_start, subscription.trial_end
      )
      dl data
    end

    private

    def add_date_if_set(data, text_sym, date_start, date_end)
      if date_start || date_end
        data[text_sym.l] = date_range(date_start, date_end)
      end
      data
    end
  end
end
