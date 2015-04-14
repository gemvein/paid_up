module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_one :subscription, as: :subscriber, class_name: 'PaidUp::Subscription'
        has_one :plan, through: :subscription, class_name: 'PaidUp::Plan'
        has_many :features_plans, through: :plan, class_name: 'PaidUp::FeaturesPlan'
        has_many :features, through: :features_plans, class_name: 'PaidUp::Feature'

        self.send(:define_method, :is_subscribed_to?) { |plan_to_check|
          if plan.nil? && plan_to_check.name == PaidUp.configuration.default_plan_name
            true
          elsif !plan.nil? && plan_to_check.id == plan.id && subscription.is_current?
            true
          end
          false
        }
        self.send(:define_method, :can_upgrade_to?) { |plan_to_check|
          if plan.nil?
            true
          else
            !is_subscribed_to? && (plan_to_check.sort > plan.sort)
          end
        }
        self.send(:define_method, :can_downgrade_to?) { |plan_to_check|
          !plan.nil? && !is_subscribed_to? && (plan_to_check.sort < plan.sort)
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