module PaidUp::Mixins
  module Subscriber
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        features = PaidUp::Feature.find_all_by_setting_type('table_rows')
        for feature in features
          has_many feature.slug.to_sym
        end

        after_initialize :set_default_attributes, :load_stripe_data
        before_save :remove_anonymous_association

        self.send(:define_method, :reload) { |*args, &blk|
          super *args, &blk
          load_stripe_data
          self
        }
        self.send(:define_method, :stripe_data) {
          if stripe_id.present? || new_record?
            @customer_stripe_data
          end
        }
        self.send(:define_method, :cards) {
          if stripe_data.present?
            stripe_data.sources.all(:object => "card")
          else
            nil
          end
        }
        self.send(:define_method, :subscribe_to_plan) { |plan_to_set, stripeToken = nil|
          if stripe_id.present? && !subscription.nil? # There is an existing subscription
            if stripeToken.present? # The customer has entered a new card
              subscription.source = stripeToken
              subscription.save
              reload
            end
            if coupon_code.present?
              stripe_data.coupon = coupon_code
              stripe_data.save
            end
            subscription.plan = plan_to_set.stripe_id
            result = subscription.save || ( raise(:could_not_update_subscription.l) && false )
          else # Totally new subscription
            args = {
              source: stripeToken,
              plan: plan_to_set.stripe_id,
              email: email
            }
            if coupon_code.present?
              args[:coupon] = coupon_code
            end
            customer = Stripe::Customer.create(args) || ( raise(:could_not_create_subscription.l) && false )

            if stripe_id != customer.id # There is an update to be made, so we go ahead
              result = update_attributes(stripe_id: customer.id) || ( raise(:could_not_associate_subscription.l) && false )
            else
              result = true
            end
          end
          if result
            Rails.cache.delete("#{stripe_id}/stripe_data")
            reload
            return true
          else
            return false
          end
        }
        self.send(:define_method, :subscribe_to_free_plan) {
          subscribe_to_plan PaidUp::Plan.free
        }
        self.send(:define_method, :plan) {
          PaidUp::Plan.find_by_stripe_id(subscription.plan.id)
        }
        self.send(:define_method, :table_rows_unlimited?) { |table_name|
          table_rows_allowed(table_name) == PaidUp::Unlimited.to_i
        }
        self.send(:define_method, :table_rows_remaining) { |table_name|
          table_rows_allowed(table_name) - table_rows(table_name)
        }
        self.send(:define_method, :table_rows_allowed) { |table_name|
          plan.feature_setting table_name
        }
        self.send(:define_method, :table_rows) { |table_name|
          send(table_name).size
        }
        self.send(:define_method, :rolify_rows_unlimited?) { |table_name|
          rolify_rows_allowed(table_name) == PaidUp::Unlimited.to_i
        }
        self.send(:define_method, :rolify_rows_remaining) { |table_name|
          rolify_rows_allowed(table_name) - rolify_rows(table_name)
        }
        self.send(:define_method, :rolify_rows_allowed) { |table_name|
          plan.feature_setting table_name
        }
        self.send(:define_method, :rolify_rows) { |table_name|
          records = table_name.classify.constantize.with_role(:owner, self)
          records.size
        }
        self.send(:define_method, :plan_stripe_id) {
         if subscription.nil?
            return nil
          end
          subscription.plan.id
        }
        self.send(:define_method, :subscription) {
          if stripe_data.nil?
            subscribe_to_free_plan
          end
          stripe_data.subscriptions.data.first
        }
        self.send(:define_method, :is_subscribed_to?) { |plan_to_check|
          plan.id == plan_to_check.id
        }
        self.send(:define_method, :can_upgrade_to?) { |plan_to_check|
          !is_subscribed_to?(plan_to_check) && (plan_to_check.sort_order.to_i > plan.sort_order.to_i)
        }
        self.send(:define_method, :can_downgrade_to?) { |plan_to_check|
          !is_subscribed_to?(plan_to_check) && (plan_to_check.sort_order.to_i < plan.sort_order.to_i)
        }
        self.send(:define_method, :using_free_plan?) {
          plan.stripe_id == PaidUp.configuration.free_plan_stripe_id || stripe_data.delinquent
        }
        self.send(:define_method, :set_default_attributes) {
          if new_record?
            self.stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
          end
        }
        self.send(:private, :set_default_attributes)
        self.send(:define_method, :load_stripe_data) {
          if new_record?
            working_stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
          else
            unless stripe_id.present?
              subscribe_to_free_plan
            end
            working_stripe_id = stripe_id
          end

          @customer_stripe_data = Rails.cache.fetch("#{working_stripe_id}/stripe_data", expires_in: 12.hours) do
            Stripe::Customer.retrieve working_stripe_id
          end

          if @customer_stripe_data.nil?
            raise :could_not_load_subscription.l
          end
        }
        self.send(:private, :load_stripe_data)
        self.send(:define_method, :remove_anonymous_association) {
          if stripe_id == PaidUp.configuration.anonymous_customer_stripe_id
            self.stripe_id = nil
          end
        }
        self.send(:private, :remove_anonymous_association)
      end
    end
  end
end