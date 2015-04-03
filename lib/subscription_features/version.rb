module SubscriptionFeatures
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))
  
  def self.version_string
    "SubscriptionFeatures version #{SubscriptionFeatures::VERSION}"
  end
end
