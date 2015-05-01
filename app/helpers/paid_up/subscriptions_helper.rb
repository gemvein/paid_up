module PaidUp
  module SubscriptionsHelper
    include PaidUp::PaidUpHelper

    def subscription_data(plan)
      {
          key: Rails.configuration.stripe[:publishable_key],
          email: @current_subscriber.email,
          amount: plan.amount,
          name: plan.stripe_data.name,
          description: plan.stripe_data.statement_descriptor,
          image: '/128x128.png'
      }
    end

    def subscription_dl(subscription)
      data = {}

      data[:status.l] = subscription.status

      if subscription.current_period_start || subscription.current_period_end
        data[:paid_thru.l]= date_range(subscription.current_period_start, subscription.current_period_end)
      end

      if subscription.trial_start || subscription.trial_end
        data[:trial_period.l]= date_range(subscription.trial_start, subscription.trial_end)
      end

      dl data, class: 'dl-horizontal'
    end
  end
end