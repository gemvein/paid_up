module SubscriptionFeatures
  module Mixins
    extend ActiveSupport::Concern
    class_methods do
      def subscriber
        has_one :subscription, as: :subscriber
        has_one :plan, through: :subscription
        has_many :features_plans, through: :plan
        has_many :features, through: :features_plans
      end
    end
  end
end

ActiveRecord::Base.send(:include, SubscriptionFeatures::Mixins)