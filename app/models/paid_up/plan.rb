class PaidUp::Plan < ActiveRecord::Base
  has_many :features_plans, class_name: 'PaidUp::FeaturesPlan'
  has_many :features, :through => :features_plans, class_name: 'PaidUp::Feature'
  has_many :subscriptions, class_name: 'PaidUp::Subscription'
  has_many :subscribers, :through => :subscriptions

  validates_presence_of :charge, :description, :name, :period, :cycles

  scope :free, -> { where(charge: 0.00) }

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

  def valid_date_phrase
    cycles.to_s + ' ' + period + ' from now'
  end

  def valid_date
    Chronic.parse(valid_date_phrase)
  end

  def self.highest
    order('charge DESC').first
  end

  def self.default
    find_by_name(PaidUp.configuration.default_plan_name) || raise(:default_plan_not_found.l)
  end
end