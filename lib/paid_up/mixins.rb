module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        attr_reader :stripe_data

        after_initialize :set_default_attributes, :load_stripe_data
        before_save :remove_anonymous_association

        self.send(:define_method, :reload) { |*args, &blk|
          super *args, &blk
          load_stripe_data
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
            subscription.plan = plan_to_set.stripe_id
            result = subscription.save || ( raise(:could_not_update_subscription.l) && false )
          else # Totally new subscription
            customer = Stripe::Customer.create(
                :source => stripeToken,
                :plan => plan_to_set.stripe_id,
                :email => email
            ) || ( raise(:could_not_create_subscription.l) && false )

            if stripe_id != customer.id # There is an update to be made, so we go ahead
              result = update_attributes(stripe_id: customer.id) || ( raise(:could_not_associate_subscription.l) && false )
            else
              result = true
            end
          end
          if result
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
        self.send(:define_method, :load_stripe_data) {
          if new_record?
            working_stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
          else
            unless stripe_id.present?
              subscribe_to_free_plan
            end
            working_stripe_id = stripe_id
          end
          @customer_stripe_data = Stripe::Customer.retrieve working_stripe_id
          if @customer_stripe_data.nil?
            raise :could_not_load_subscription.l
          end
        }
        self.send(:private, :load_stripe_data)
        self.send(:define_method, :set_default_attributes) {
          if new_record?
            self.stripe_id = PaidUp.configuration.anonymous_customer_stripe_id
          end
        }
        self.send(:private, :set_default_attributes)
        self.send(:define_method, :remove_anonymous_association) {
          if stripe_id == PaidUp.configuration.anonymous_customer_stripe_id
            self.stripe_id = nil
          end
        }
        self.send(:private, :remove_anonymous_association)

        PaidUp::Plan.subscribed_to(self)
      end

      def subscribed_to(model)
        has_many :subscribers, :through => :subscriptions, :source => :subscriber, :source_type => model.model_name
      end
    end
  end
end



ActiveRecord::Base.send(:include, PaidUp::Mixins)