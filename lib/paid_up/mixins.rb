module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_many :subscriptions, as: :subscriber, class_name: 'PaidUp::Subscription'
        has_many :plans, through: :subscriptions, class_name: 'PaidUp::Plan'
        has_many :features_plans, through: :plans, class_name: 'PaidUp::FeaturesPlan'
        has_many :features, through: :features_plans, class_name: 'PaidUp::Feature'

        self.send(:define_method, :plan) {
          plans.highest || PaidUp::Plan.default
        }
        self.send(:define_method, :plan=) { |plan|
          subscriptions.build(plan: plan, valid_until: plan.valid_date.to_s(:db))
        }
        self.send(:define_method, :is_subscribed_to?) { |plan_to_check|
          if plans.empty?
            plan_to_check == PaidUp::Plan.default
          else
            plans.find_by_id(plan_to_check.id).exists?
          end
        }
        self.send(:define_method, :can_upgrade_to?) { |plan_to_check|
          if plan.nil?
            true
          else
            !is_subscribed_to? plan_to_check && (plan_to_check.sort > plan.sort)
          end
        }
        self.send(:define_method, :can_downgrade_to?) { |plan_to_check|
          !plan.nil? && (!is_subscribed_to? plan_to_check) && (plan_to_check.sort < plan.sort)
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