module SubscriptionFeatures
  def self.configure(configuration = SubscriptionFeatures::Configuration.new)
    if block_given?
      yield configuration
    end
    @@configuration = configuration
  end
  
  def self.configuration
    @@configuration ||= SubscriptionFeatures::Configuration.new
  end
  
  class Configuration
    attr_accessor :application_name, :application_description, :application_keywords
    
    def initialize
      self.application_name = "TODO"
      self.application_description = "TODO"
      self.application_keywords = "TODO"
    end
  end
end