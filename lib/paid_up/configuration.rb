module PaidUp
  def self.configure(configuration = PaidUp::Configuration.new)
    if block_given?
      yield configuration
    end
    @@configuration = configuration
  end

  def self.configuration
    @@configuration ||= PaidUp::Configuration.new
  end

  class Configuration
    attr_accessor :anonymous_customer_stripe_id, :anonymous_plan_stripe_id, :free_plan_stripe_id, :features

    def initialize
      self.anonymous_customer_stripe_id = "TODO"
      self.anonymous_plan_stripe_id = "TODO"
      self.free_plan_stripe_id = "TODO"
      self.features = {}
    end
  end
end