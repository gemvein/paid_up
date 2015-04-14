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
    attr_accessor :current_subscriber_method, :default_subscriber_method, :default_plan_name
    
    def initialize
      self.current_subscriber_method = "TODO"
      self.default_subscriber_method = "TODO"
      self.default_plan_name = "TODO"
    end
  end
end