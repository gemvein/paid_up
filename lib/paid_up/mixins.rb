module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        attr_reader :stripe_data

        after_find :load_stripe_data

        self.send(:define_method, :load_stripe_data) {
          if stripe_id.present?
            @customer_stripe_data = Stripe::Customer.retrieve stripe_id
          end
        }
        self.send(:define_method, :stripe_data) {
          if stripe_id.present?
            @customer_stripe_data
          end
        }
        self.send(:define_method, :subscribe_to_plan) { |stripe_token, plan|
          if plan.stripe_id.present?
            customer = Stripe::Customer.create(
                :source => stripe_token,
                :plan => plan.stripe_id,
                :email => email
            )

            update_attributes(stripe_id: customer.id)
          elsif stripe_id.present?
              customer = Stripe::Customer.retrieve(stripe_id)
              customer.at_period_end = true
              customer.save
          else
            #nothing to do
          end
          reload
          load_stripe_data
        }
        self.send(:define_method, :plan) {
          if stripe_id.present?
            PaidUp::Plan.find_by_stripe_id(plan_stripe_id)
          else
            PaidUp::Plan.default
          end
        }
        self.send(:define_method, :plan_stripe_id) {
          subscription.plan.id
        }
        self.send(:define_method, :subscription) {
          if stripe_data.nil?
            load_stripe_data
          end
          stripe_data.subscriptions.data.first
        }
        self.send(:define_method, :is_subscribed_to?) { |plan_to_check|
          plan == plan_to_check
        }
        self.send(:define_method, :can_upgrade_to?) { |plan_to_check|
          !is_subscribed_to?(plan_to_check) && (plan_to_check.sort > plan.sort)
        }
        self.send(:define_method, :can_downgrade_to?) { |plan_to_check|
          !is_subscribed_to?(plan_to_check) && (plan_to_check.sort < plan.sort)
        }
        self.send(:define_method, :using_default_plan?) {
          !plan.stripe_id.present? || stripe_data.delinquent
        }

        PaidUp::Plan.subscribed_to(self)
      end

      def subscribed_to(model)
        has_many :subscribers, :through => :subscriptions, :source => :subscriber, :source_type => model.model_name
      end
    end
  end
end

ActiveRecord::Base.send(:include, PaidUp::Mixins)