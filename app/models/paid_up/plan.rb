class PaidUp::Plan < ActiveRecord::Base
  has_many :features_plans, class_name: 'PaidUp::FeaturesPlan'
  has_many :features, :through => :features_plans, class_name: 'PaidUp::Feature'
  has_many :subscriptions, class_name: 'PaidUp::Subscription'
  has_many :subscribers, :through => :subscriptions

  validates_presence_of :charge, :description, :name, :period, :cycles

  def feature_setting(name)
    feature = PaidUp::Feature.find_by_name(name)
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