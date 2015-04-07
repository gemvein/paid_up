class SubscriptionFeatures::Plan < ActiveRecord::Base
  has_many :features_plans
  has_many :features, :through => :features_plans
  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions

  validates_presence_of :charge, :description, :name, :period, :cycles

  def feature_setting(name)
    feature = Feature.find_by_name(name)
    raw = features_plans.find_by_feature_name(name)
    if raw.nil?
      if feature.setting_type == 'boolean'
        false
      else
        0
      end
    else
      if feature.setting_type == 'boolean'
        if raw.setting > 0 || raw.setting == -1
          true
        else
          false
        end
      else
        raw.setting
      end
    end
  end

  def feature_unlimited?(name)
    feature_setting(name) == -1
  end
end