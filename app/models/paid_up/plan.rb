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

    after_initialize :load_stripe_data
    after_save :expire_stripe_data

    attr_accessor :stripe_data

    validates_presence_of :title, :stripe_id
    validates_uniqueness_of :title

    default_scope { order('sort_order ASC') }
    scope :subscribable, -> { where('sort_order >=  ?', 0) }
    scope :free, (lambda do
      find_by_stripe_id(PaidUp.configuration.free_plan_stripe_id)
    end)

    def reload(*args, &blk)
      super(*args, &blk)
      load_stripe_data
      self
    end

    def feature_setting(feature_name)
      feature = PaidUp::Feature.find_by_slug(feature_name) ||
                raise(:feature_not_found.l)
      raw = plan_feature_settings.where(feature: feature_name)
      setting = raw.first.setting
      case feature.setting_type
      when 'boolean'
        if raw.empty?
          false
        else
          setting != 0
        end
      when 'table_rows', 'rolify_rows'
        if raw.empty?
          0
        else
          setting
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
      ) do
        Stripe::Plan.retrieve stripe_id
      end
    end

    def expire_stripe_data
      Rails.cache.delete("#{stripe_id}/stripe_data")
    end
  end
end
