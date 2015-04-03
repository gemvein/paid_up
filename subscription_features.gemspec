$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "subscription_features/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "subscription_features"
  s.version     = SubscriptionFeatures::VERSION
  s.authors     = ["Karen Lundgren"]
  s.email       = ["karen.e.lundgren@gmail.com"]
  s.homepage    = "http://www.gemvein.com"
  s.summary     = "Allows a model of your choosing to subscribe to a plan, which enables features."
  s.description = "Allows a model of your choosing (such as users) to subscribe to a plan, which enables features."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"

  s.add_development_dependency "sqlite3"
end
