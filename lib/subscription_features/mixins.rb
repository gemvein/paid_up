module SubscriptionFeatures
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_one :subscription, as: :subscriber
        has_one :plan, through: :subscription
        has_many :features_plans, through: :plan
        has_many :features, through: :features_plans

        Plan.subscribed_to(self)
      end

      def subscribed_to(model)
        has_many :subscribers, :through => :subscriptions, :source => :subscriber, :source_type => model.model_name
      end
    end
  end
end

ActiveRecord::Base.send(:include, SubscriptionFeatures::Mixins)