# PaidUp Module
module PaidUp
  def self.configure(configuration = PaidUp::Configuration.new)
    block_given? && yield(configuration)
    @configuration = configuration
  end

  def self.configuration
    @configuration ||= PaidUp::Configuration.new
  end

  # PaidUp Configuration
  class Configuration
    attr_accessor(
      :anonymous_customer_stripe_id,
      :anonymous_plan_stripe_id,
      :free_plan_stripe_id,
      :features
    )

    def initialize
      self.anonymous_customer_stripe_id = 'TODO'
      self.anonymous_plan_stripe_id = 'TODO'
      self.free_plan_stripe_id = 'TODO'
      self.features = {}
    end
  end
end
