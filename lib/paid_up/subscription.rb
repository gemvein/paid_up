# frozen_string_literal: true

# PaidUp module
module PaidUp
  # Subscription Class: Not an ActiveRecord object.
  class Subscription
    include ActiveModel::Model
    include ActiveModel::AttributeMethods

    attr_accessor :stripe_data, :user
    delegate :status, :trial_start, :trial_end, :current_period_start,
             :current_period_end, :cancel_at_period_end, to: :stripe_data
    delegate :email, :stripe_id, to: :user

    def initialize(args)
      super args
      self.stripe_data = user.stripe_data.subscriptions.first
    end

    def plan
      if stripe_data&.plan&.id.present?
        PaidUp::Plan.find_by_stripe_id(stripe_data.plan.id)
      else
        PaidUp::Plan.free
      end
    end

    def update(plan, stripe_token = nil, coupon = nil, trial_end = nil)
      return if stripe_data.nil?
      update_stripe_token(stripe_token)
      update_coupon(coupon)
      update_trial_end(trial_end)
      update_plan(plan)
      stripe_data.save || raise(:could_not_update_plan.l)
    end

    def create(plan, stripe_token = nil, coupon = nil, trial_end = nil)
      customer = Stripe::Customer.create(source: stripe_token, email: email,
                                         plan: plan.stripe_id, coupon: coupon,
                                         trial_end: trial_end) ||
                 raise(:could_not_create_subscription.l)

      # If there is an update to be made, we go ahead
      return true if stripe_id == customer.id
      user.update_attribute(:stripe_id, customer.id) ||
        raise(:could_not_associate_subscription.l)
    end

    private

    def update_stripe_token(stripe_token)
      return unless stripe_token.present?
      # The customer has entered a new card
      # We need to update the info on the Stripe API.
      stripe_data.source = stripe_token
    end

    def update_coupon(coupon)
      return unless coupon.present?
      # The customer has entered a new coupon code
      # We need to update the stripe customer.
      stripe_data.coupon = coupon
    end

    def update_trial_end(trial_end)
      return unless trial_end.present?
      # The customer has cancelled or otherwise altered their trial_end
      # We need to update the info on the Stripe API.
      # stripe_data.stripe_data.trial_end = trial_end
      # stripe_data.stripe_data.save!
      stripe_data.trial_end = trial_end
    end

    def update_plan(new_plan)
      return unless new_plan.present?
      # The customer has changed plans
      # We need to update the info on the Stripe API.
      stripe_data.plan = new_plan.stripe_id
    end
  end
end
