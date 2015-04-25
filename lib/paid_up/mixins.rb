module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_many :features_plans, through: :plan, class_name: 'PaidUp::FeaturesPlan'
        has_many :features, through: :features_plans, class_name: 'PaidUp::Feature'

        attr_accessor :stripe_data

        after_find :load_stripe_data

        self.send(:define_method, :load_stripe_data) {
          if stripe_id.present?
            @customer_stripe_data = Stripe::Customer.retrieve stripe_id
          end
        }
        self.send(:define_method, :plan) {
          if stripe_id.present?
            PaidUp::Plan.find_by_stripe_id(@customer_stripe_data.subscriptions.data.first.plan.id)
          else
            PaidUp::Plan.default
          end
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
          !plan.stripe_id.present? || @customer_stripe_data.delinquent
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