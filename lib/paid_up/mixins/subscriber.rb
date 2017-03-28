module PaidUp
  module Mixins
    # Subscriber Mixin
    module Subscriber
      extend ActiveSupport::Concern

      def subscriber
        features = PaidUp::Feature.find_all_by_setting_type('table_rows')
        features.each do |feature|
          has_many feature.slug.to_sym
        end

        after_initialize :set_default_attributes, :load_stripe_data
        before_save :remove_anonymous_association
        before_destroy { |record| record.stripe_data.delete }
        include InstanceMethods
      end

      # Included by subscriber mixin
      module InstanceMethods
        def reload(*args, &blk)
          super(*args, &blk)
          load_stripe_data
          self
        end

        def stripe_data
          (stripe_id.present? || new_record?) && @customer_stripe_data
        end

        def cards
          stripe_data.present? && stripe_data.sources.all(object: 'card')
        end

        def subscribe_to_plan(
          plan_to_set, stripe_token = nil, coupon_code = nil, trial_end = nil
        )
          # If there is an existing subscription
          if stripe_id.present? && subscription.present?
            update_subscription(
              plan_to_set, stripe_token, coupon_code, trial_end
            )
          else # Totally new subscription
            new_subscription(
              plan_to_set, stripe_token, coupon_code, trial_end
            )
          end
          Rails.cache.delete("#{stripe_id}/stripe_data")
          reload
        end

        def new_subscription(
          plan_to_set, stripe_token = nil, coupon_code = nil, trial_end = nil
        )
          args = {
            source: stripe_token,
            plan: plan_to_set.stripe_id,
            email: email,
            trial_end: trial_end
          }
          args[:coupon] = coupon_code if coupon_code.present?

          customer = Stripe::Customer.create(args)
          raise(:could_not_create_subscription.l) unless customer.present?

          # If there is an update to be made, we go ahead
          return true if stripe_id == customer.id
          update_attributes(stripe_id: customer.id) ||
            raise(:could_not_associate_subscription.l)
        end

        def update_subscription(
          plan_to_set, stripe_token = nil, coupon_code = nil, trial_end = nil
        )
          update_stripe_token(stripe_token)
          update_coupon_code(coupon_code)
          update_trial_end(trial_end)
          update_plan(plan_to_set)
        end

        def subscribe_to_free_plan
          subscribe_to_plan PaidUp::Plan.free
        end

        def plan
          if subscription.present?
            PaidUp::Plan.find_by_stripe_id(subscription.plan.id)
          else
            PaidUp::Plan.free
          end
        end

        def table_rows_unlimited?(table_name)
          table_rows_allowed(table_name) == PaidUp::Unlimited.to_i
        end

        def table_rows_remaining(table_name)
          table_rows_allowed(table_name) - table_rows_count(table_name)
        end

        def table_rows_allowed(table_name)
          plan.feature_setting table_name
        end

        def table_rows(table_name)
          model = table_name.classify.constantize
          model.where(user: self).paid_for_scope
        end

        def table_rows_count(table_name)
          table_rows(table_name).size
        end

        def rolify_rows_unlimited?(table_name)
          rolify_rows_allowed(table_name) == PaidUp::Unlimited.to_i
        end

        def rolify_rows_remaining(table_name)
          rolify_rows_allowed(table_name) - rolify_rows_count(table_name)
        end

        def rolify_rows_allowed(table_name)
          plan.feature_setting table_name
        end

        def rolify_rows(table_name)
          model = table_name.classify.constantize
          model.with_role(:owner, self).paid_for_scope
        end

        def rolify_rows_count(table_name)
          rolify_rows(table_name).paid_for_scope.size
        end

        def plan_stripe_id
          subscription.nil? && return
          subscription.plan.id
        end

        def subscription
          stripe_data.nil? && subscribe_to_free_plan
          stripe_data.subscriptions.data.first
        end

        def subscribed_to?(plan_to_check)
          plan.present? && plan.id == plan_to_check.id
        end

        def can_upgrade_to?(plan_to_check)
          plan.nil? || (
            !subscribed_to?(plan_to_check) &&
            (plan_to_check.sort_order.to_i > plan.sort_order.to_i)
          )
        end

        def can_downgrade_to?(plan_to_check)
          !plan.nil? && (
            !subscribed_to?(plan_to_check) &&
            (plan_to_check.sort_order.to_i < plan.sort_order.to_i)
          )
        end

        def using_free_plan?
          plan.nil? ||
            stripe_data.delinquent ||
            (plan.stripe_id == PaidUp.configuration.free_plan_stripe_id)
        end

        private

        def update_stripe_token(stripe_token)
          return unless stripe_token.present?
          # The customer has entered a new card
          # We need to update the info on the Stripe API.
          subscription.source = stripe_token
          subscription.save || raise(:could_not_update_card.l)
          reload # This causes load_stripe_data to fire
        end

        def update_coupon_code(coupon_code)
          return unless coupon_code.present?
          # The customer has entered a new coupon code
          # We need to update the stripe customer.
          stripe_data.coupon = coupon_code
          stripe_data.save || raise(:could_not_update_coupon.l)
        end

        def update_trial_end(trial_end)
          return unless trial_end.present?
          # The customer has cancelled or otherwise altered their trial_end
          # We need to update the info on the Stripe API.
          # stripe_data.subscription.trial_end = trial_end
          # stripe_data.subscription.save!
          subscription.trial_end = trial_end
          subscription.save || raise(:could_not_update_cancel.l)
        end

        def update_plan(plan_to_set)
          return unless plan_to_set.present?
          # The customer has changed plans
          # We need to update the info on the Stripe API.
          subscription.plan = plan_to_set.stripe_id
          subscription.save || raise(:could_not_update_plan.l)
        end

        def set_default_attributes
          return unless new_record?
          self.stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
        end

        def load_stripe_data
          stripe_id = working_stripe_id

          @customer_stripe_data = Rails.cache.fetch(
            "#{stripe_id}/stripe_data",
            expires_in: 12.hours
          ) do
            Stripe::Customer.retrieve stripe_id
          end

          raise(:could_not_load_subscription.l) if @customer_stripe_data.nil?
          stripe_data
        end

        def working_stripe_id
          if new_record?
            PaidUp.configuration.anonymous_customer_stripe_id
          else
            subscribe_to_free_plan unless stripe_id.present?
            stripe_id
          end
        end

        def remove_anonymous_association
          return unless stripe_id ==
                        PaidUp.configuration.anonymous_customer_stripe_id
          self.stripe_id = nil
        end
      end
    end
  end
end
