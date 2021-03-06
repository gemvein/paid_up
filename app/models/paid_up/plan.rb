# frozen_string_literal: true

module PaidUp
  # PaidUp Plan model
  class Plan < ActiveRecord::Base
    has_many(
      :plan_feature_settings,
      class_name: 'PaidUp::PlanFeatureSetting',
      foreign_key: 'paid_up_plan_id',
      inverse_of: :plan
    )
    accepts_nested_attributes_for :plan_feature_settings

    after_initialize :load_stripe_data, :load_feature_settings
    after_save :expire_stripe_data

    attr_accessor :stripe_data

    validates_presence_of :title, :stripe_id
    validates_uniqueness_of :title, case_sensitive: true

    default_scope { order('sort_order ASC') }
    scope :subscribable, -> { where('sort_order >=  ?', 0) }
    scope :including_ids, ->(ids) { where(id: ids) }
    scope :excluding_ids, ->(ids) { where.not(id: ids) }
    scope :free, (lambda do
      find_by_stripe_id(PaidUp.configuration.free_plan_stripe_id)
    end)
    scope :display, (lambda do |including, excluding|
      plans = subscribable
      plans = plans.including_ids(including) if including.present?
      plans = plans.excluding_ids(excluding) if excluding.present?
      plans
    end)

    def reload(*args, &blk)
      super(*args, &blk)
      load_stripe_data
      self
    end

    def load_feature_settings
      @feature_settings = {}
      settings = {}

      plan_feature_settings.each do |feature_setting|
        settings[feature_setting.feature] = feature_setting.setting
      end

      PaidUp::Feature.all.each do |feature|
        slug = feature.slug
        @feature_settings[slug] = parse_setting_by_type(feature.setting_type, settings[slug])
      end
    end

    def parse_setting_by_type(setting_type, setting)
      case setting_type
      when 'boolean'
        setting == 1
      when 'table_rows', 'rolify_rows'
        setting || 0
      else
        raise :error_handling_feature_setting.l feature: feature
      end
    end

    def feature_setting(feature_name)
      @feature_settings[feature_name]
    end

    def feature_unlimited?(feature_name)
      feature_setting(feature_name) == PaidUp::Unlimited.to_i
    end

    def interval
      stripe_data&.interval || :default_interval.l
    end

    def interval_count
      stripe_data&.interval_count || 1
    end

    def amount
      stripe_data&.amount || 0
    end

    def adjusted_amount(discount)
      return amount unless adjust?(discount)
      adjusted = amount
      adjusted -= (discount.coupon.percent_off || 0) * 0.01 * adjusted
      adjusted -= (discount.coupon.amount_off || 0)
      [adjusted, 0].max
    end

    def money
      Money.new(amount, currency)
    end

    def adjusted_money(discount)
      Money.new(adjusted_amount(discount), currency)
    end

    def adjust?(discount)
      discount.present? && discount.coupon.present? && !amount.zero?
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
      return unless stripe_id.present?
      self.stripe_data = Rails.cache.fetch(
        "#{stripe_id}/stripe_data", expires_in: 1.minute
      ) { Stripe::Plan.retrieve stripe_id }
    end

    def expire_stripe_data
      Rails.cache.delete("#{stripe_id}/stripe_data")
    end
  end
end
