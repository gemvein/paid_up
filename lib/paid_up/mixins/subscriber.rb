# frozen_string_literal: true

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

        delegate :plan, to: :paid_up_subscription
        after_initialize :set_default_attributes, :load_stripe_data
        after_save :load_stripe_data
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
          new_plan, stripe_token = nil, coupon = nil, trial_end = nil
        )
          # If there is an existing subscription
          if stripe_id.present? && paid_up_subscription.present?
            paid_up_subscription.update(new_plan, stripe_token, coupon, trial_end)
          else # Totally new subscription
            paid_up_subscription.create(new_plan, stripe_token, coupon, trial_end)
          end
          Rails.cache.delete("#{stripe_id}/stripe_data")
          reload
        end

        def subscribe_to_free_plan
          subscribe_to_plan PaidUp::Plan.free
        end

        def table_setting(table_name)
          PaidUp::TableFeatureSettingType.new(name: table_name, user: self)
        end

        def rolify_setting(table_name)
          PaidUp::RolifyFeatureSettingType.new(name: table_name, user: self)
        end

        def plan_stripe_id
          paid_up_subscription&.stripe_data&.plan&.id
        end

        def paid_up_subscription
          stripe_data.nil? && subscribe_to_free_plan
          @subscription
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
          plan.present? && (
            !subscribed_to?(plan_to_check) &&
            (plan_to_check.sort_order.to_i < plan.sort_order.to_i)
          )
        end

        def using_free_plan?
          plan.nil? || stripe_data.delinquent ||
            plan.stripe_id == PaidUp.configuration.free_plan_stripe_id
        end

        private

        def set_default_attributes
          return unless new_record?
          self.stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
        end

        def load_stripe_data
          @customer_stripe_data = Rails.cache.fetch(
            "#{working_stripe_id}/stripe_data",
            expires_in: 12.hours
          ) do
            Stripe::Customer.retrieve working_stripe_id
          end

          @subscription = PaidUp::Subscription.new(user: self)

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
