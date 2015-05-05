module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        attr_reader :stripe_data

        after_find :load_stripe_data

        self.send(:define_method, :stripe_data) {
          if stripe_id.present?
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
        self.send(:define_method, :card_from_token) { |token_id|
          Stripe::Token.retrieve(token_id).card
        }
        self.send(:define_method, :subscribe_to_plan) { |card_to_set, plan_to_set|
          if stripe_id.present?
            if plan_to_set.stripe_id.present?
              Stripe::Charge.create(
                amount: plan_to_set.amount,
                currency: plan_to_set.currency,
                customer: stripe_id,
                card: card_to_set
              )
            else # Cancel at period end
              customer = Stripe::Customer.retrieve(stripe_id)
              customer.at_period_end = true
              customer.save
            end
          else
            customer = Stripe::Customer.create(
                :card => card_to_set,
                :plan => plan_to_set.stripe_id,
                :email => email
            )

            update_attributes(stripe_id: customer.id)
          end
          load_stripe_data
        }
        self.send(:define_method, :update_card) { |token|
          if stripe_id.present?
            customer = Stripe::Customer.retrieve(stripe_id)
            customer.source = token
            customer.save
          else
            customer = Stripe::Customer.create(
                :source => token,
                :email => email
            )

            update_attributes(stripe_id: customer.id)
          end
          load_stripe_data
          card_from_token token
        }
        self.send(:define_method, :plan) {
          if stripe_id.present?
            PaidUp::Plan.find_by_stripe_id(plan_stripe_id)
          else
            PaidUp::Plan.default
          end
        }
        self.send(:define_method, :plan_stripe_id) {
          if subscription.nil?
            return nil
          end
          subscription.plan.id
        }
        self.send(:define_method, :subscription) {
          if stripe_data.nil?
            return nil
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

        self.send(:define_method, :load_stripe_data) {
          if stripe_id.present?
            @customer_stripe_data = Stripe::Customer.retrieve stripe_id
          end
        }
        self.send(:private, :load_stripe_data)

        PaidUp::Plan.subscribed_to(self)
      end

      def subscribed_to(model)
        has_many :subscribers, :through => :subscriptions, :source => :subscriber, :source_type => model.model_name
      end
    end
  end
end

ActiveRecord::Base.send(:include, PaidUp::Mixins)