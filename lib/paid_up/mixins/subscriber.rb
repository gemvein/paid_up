module PaidUp
  module Mixins
    # Subscriber Mixin
    module Subscriber
      extend ActiveSupport::Concern
      class_methods do
        def subscriber
          features = PaidUp::Feature.find_all_by_setting_type('table_rows')
          features.each do |feature|
            has_many feature.slug.to_sym
          end

          after_initialize :set_default_attributes, :load_stripe_data
          before_save :remove_anonymous_association
          before_destroy { |record| record.stripe_data.delete }

          send(:define_method, :reload) do |*args, &blk|
            super(*args, &blk)
            load_stripe_data
            self
          end
          send(:define_method, :stripe_data) do
            (stripe_id.present? || new_record?) && @customer_stripe_data
          end
          send(:define_method, :cards) do
            stripe_data.present? && stripe_data.sources.all(object: 'card')
          end
          send(
            :define_method,
            :subscribe_to_plan
          ) do |plan_to_set, stripe_token = nil, trial_end = nil|
            # If there is an existing subscription
            if stripe_id.present? && !subscription.nil?
              if stripe_token.present? # The customer has entered a new card
                subscription.source = stripe_token
                subscription.save
                reload
              end
              if coupon_code.present?
                stripe_data.coupon = coupon_code
                stripe_data.save
              end
              if trial_end.present?
                stripe_data.subscription.trial_end = trial_end
                stripe_data.subscription.save
              end
              subscription.plan = plan_to_set.stripe_id
              result = subscription.save ||
                       (raise(:could_not_update_subscription.l) && false)
            else # Totally new subscription
              args = {
                source: stripe_token,
                plan: plan_to_set.stripe_id,
                email: email,
                trial_end: trial_end
              }
              coupon_code.present? && args[:coupon] = coupon_code
              customer = Stripe::Customer.create(args) ||
                         (raise(:could_not_create_subscription.l) && false)

              # If there is an update to be made, we go ahead
              if stripe_id != customer.id
                result = update_attributes(stripe_id: customer.id) ||
                         (raise(:could_not_associate_subscription.l) && false)
              else
                result = true
              end
            end
            result && Rails.cache.delete("#{stripe_id}/stripe_data") && reload
          end
          send(:define_method, :subscribe_to_free_plan) do
            subscribe_to_plan PaidUp::Plan.free
          end
          send(:define_method, :plan) do
            if subscription.present?
              PaidUp::Plan.find_by_stripe_id(subscription.plan.id)
            else
              PaidUp::Plan.free
            end
          end
          send(:define_method, :table_rows_unlimited?) do |table_name|
            table_rows_allowed(table_name) == PaidUp::Unlimited.to_i
          end
          send(:define_method, :table_rows_remaining) do |table_name|
            table_rows_allowed(table_name) - table_rows(table_name)
          end
          send(:define_method, :table_rows_allowed) do |table_name|
            plan.feature_setting table_name
          end
          send(:define_method, :table_rows) do |table_name|
            send(table_name).size
          end
          send(:define_method, :rolify_rows_unlimited?) do |table_name|
            rolify_rows_allowed(table_name) == PaidUp::Unlimited.to_i
          end
          send(:define_method, :rolify_rows_remaining) do |table_name|
            rolify_rows_allowed(table_name) - rolify_rows(table_name)
          end
          send(:define_method, :rolify_rows_allowed) do |table_name|
            plan.feature_setting table_name
          end
          send(:define_method, :rolify_rows) do |table_name|
            records = table_name.classify.constantize.with_role(:owner, self)
            records.size
          end
          send(:define_method, :plan_stripe_id) do
            subscription.nil? && return
            subscription.plan.id
          end
          send(:define_method, :subscription) do
            stripe_data.nil? && subscribe_to_free_plan
            stripe_data.subscriptions.data.first
          end
          send(:define_method, :is_subscribed_to?) do |plan_to_check|
            plan.present? && plan.id == plan_to_check.id
          end
          send(:define_method, :can_upgrade_to?) do |plan_to_check|
            plan.nil? || (
              !is_subscribed_to?(plan_to_check) &&
              (plan_to_check.sort_order.to_i > plan.sort_order.to_i)
            )
          end
          send(:define_method, :can_downgrade_to?) do |plan_to_check|
            !plan.nil? && (
              !is_subscribed_to?(plan_to_check) &&
              (plan_to_check.sort_order.to_i < plan.sort_order.to_i)
            )
          end
          send(:define_method, :using_free_plan?) do
            plan.nil? ||
              stripe_data.delinquent ||
              (plan.stripe_id == PaidUp.configuration.free_plan_stripe_id)
          end
          send(:define_method, :set_default_attributes) do
            if new_record?
              self.stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
            end
          end
          send(:private, :set_default_attributes)
          send(:define_method, :load_stripe_data) do
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
          send(:private, :load_stripe_data)
          send(:define_method, :remove_anonymous_association) do
            if stripe_id == PaidUp.configuration.anonymous_customer_stripe_id
              self.stripe_id = nil
            end
          end
          send(:private, :remove_anonymous_association)
        end
      end
    end
  end
end
