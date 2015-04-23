module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_one :subscription, as: :subscriber, class_name: 'PaidUp::Subscription'
        has_one :plan, through: :subscription, class_name: 'PaidUp::Plan'
        has_many :features_plans, through: :plan, class_name: 'PaidUp::FeaturesPlan'
        has_many :features, through: :features_plans, class_name: 'PaidUp::Feature'

        self.send(:define_method, :subscribe_to_plan) { |plan_to_set|
          create_subscription!(plan: plan_to_set, valid_until: plan_to_set.valid_date.to_s(:db))
        }
        self.send(:define_method, :is_subscribed_to?) { |plan_to_check|
          effective_plan == plan_to_check
        }
        self.send(:define_method, :can_upgrade_to?) { |plan_to_check|
          !is_subscribed_to?(plan_to_check) && (plan_to_check.sort > effective_plan.sort)
        }
        self.send(:define_method, :can_downgrade_to?) { |plan_to_check|
          !is_subscribed_to?(plan_to_check) && (plan_to_check.sort < effective_plan.sort)
        }
        self.send(:define_method, :using_default_plan?) {
          effective_plan.name == PaidUp.configuration.default_plan_name
        }
        self.send(:define_method, :effective_plan) {
          plan || PaidUp::Plan.default
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