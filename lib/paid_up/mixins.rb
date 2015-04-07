module PaidUp
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_one :subscription, as: :subscriber, class_name: 'PaidUp::Subscription'
        has_one :plan, through: :subscription, class_name: 'PaidUp::Plan'
        has_many :features_plans, through: :plan, class_name: 'PaidUp::FeaturesPlan'
        has_many :features, through: :features_plans, class_name: 'PaidUp::Feature'

        PaidUp::Plan.subscribed_to(self)
      end

      def subscribed_to(model)
        has_many :subscribers, :through => :subscriptions, :source => :subscriber, :source_type => model.model_name
      end
    end
  end
end

ActiveRecord::Base.send(:include, PaidUp::Mixins)