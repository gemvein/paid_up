class PaidUp::Plan < ActiveRecord::Base
  has_many :features_plans, class_name: 'PaidUp::FeaturesPlan'
  has_many :features, :through => :features_plans, class_name: 'PaidUp::Feature'

  validates_presence_of :description, :name

  after_find :load_stripe_data

  attr_accessor :stripe_data

  scope :default, -> { where('stripe_id IS NULL').first }

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

  def load_stripe_data
    if stripe_id.present?
      self.stripe_data = Stripe::Plan.retrieve stripe_id
    end
  end

  def interval
    if stripe_id.present?
      stripe_data.interval
    else
      :default_interval.l
    end
  end

  def interval_count
    if stripe_id.present?
      stripe_data.interval_count
    else
      1
    end
  end

  def amount
    if stripe_id.present?
      stripe_data.amount
    else
      0
    end
  end

  def charge
    amount/100
  end

  def currency
    if stripe_id.present?
      stripe_data.currency
    else
      :currency_unit.l
    end
  end

end