module PaidUp
  module SubscriptionsHelper
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
  end
end