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
          if stripe_token.present? # The customer has entered a new card
            subscription.source = stripe_token
            subscription.save
            reload
          end
          if coupon_code.present?
            stripe_data.coupon = coupon_code
            stripe_data.save!
          end
          if trial_end.present?
            stripe_data.subscription.trial_end = trial_end
            stripe_data.subscription.save!
          end
          subscription.plan = plan_to_set.stripe_id
          subscription.save || raise(:could_not_update_subscription.l)
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
          table_rows_allowed(table_name) - table_rows(table_name)
        end

        def table_rows_allowed(table_name)
          plan.feature_setting table_name
        end

        def table_rows(table_name)
          model = table_name.classify.constantize
          model.where(user: self).paid_for_scope.size
        end

        def rolify_rows_unlimited?(table_name)
          rolify_rows_allowed(table_name) == PaidUp::Unlimited.to_i
        end

        def rolify_rows_remaining(table_name)
          rolify_rows_allowed(table_name) - rolify_rows(table_name)
        end

        def rolify_rows_allowed(table_name)
          plan.feature_setting table_name
        end

        def rolify_rows(table_name)
          model = table_name.classify.constantize
          model.with_role(:owner, self).paid_for_scope.size
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

        def set_default_attributes
          return unless new_record?
          self.stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
        end

        def load_stripe_data
          working_stripe_id = if new_record?
                                PaidUp.configuration
                                      .anonymous_customer_stripe_id
                              else
                                !stripe_id.present? && subscribe_to_free_plan
                                stripe_id
                              end

          @customer_stripe_data = Rails.cache.fetch(
            "#{working_stripe_id}/stripe_data",
            expires_in: 12.hours
          ) do
            Stripe::Customer.retrieve working_stripe_id
          end

          @customer_stripe_data.nil? && raise(:could_not_load_subscription.l)
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
