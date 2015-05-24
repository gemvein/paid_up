class PaidUp::Plan < ActiveRecord::Base
  has_many :features_plans, class_name: 'PaidUp::FeaturesPlan'
  has_many :features, :through => :features_plans, class_name: 'PaidUp::Feature'
  has_many :subscribers, :through => :subscriptions, :source => :subscriber, :source_type => 'User'

  after_initialize :load_stripe_data

  attr_accessor :stripe_data

  validates_presence_of :name, :stripe_id

  default_scope { order('sort_order ASC') }
  scope :subscribable, -> { where('sort_order >=  ?', 0) }
  scope :free, -> { find_by_stripe_id(PaidUp.configuration.free_plan_stripe_id) }

  def reload(*args, &blk)
    super *args, &blk
    load_stripe_data
    self
  end

  def feature_setting(feature_name)
    feature = PaidUp::Feature.find_by_slug(feature_name) || raise(:feature_not_found.l)
    raw = features_plans.where(feature: feature_name)
    case feature.setting_type
      when 'boolean'
        if raw.empty?
          false
        else
          raw.first.setting != 0
        end
      when 'table_rows', 'rolify_rows'
        if raw.empty?
          0
        else
          raw.first.setting
        end
      else
        raise :error_handling_feature_setting.l feature: feature
    end
  end

  def feature_unlimited?(feature_name)
    feature_setting(feature_name) == PaidUp::Unlimited.to_i
  end

  def interval
    if stripe_data.present?
      stripe_data.interval
    else
      :default_interval.l
    end
  end

  def interval_count
    if stripe_data.present?
      stripe_data.interval_count
    else
      1
    end
  end

  def amount
    if stripe_data.present?
      stripe_data.amount
    else
      0
    end
  end

  def money
    Money.new(amount, currency)
  end

  def charge
    money.amount
  end

  def currency
    if stripe_data.present?
      stripe_data.currency.upcase
    else
      :default_currency.l.upcase
    end
  end

  private

  def load_stripe_data
    if stripe_id.present?
      self.stripe_data = Stripe::Plan.retrieve stripe_id
    end
  end

end