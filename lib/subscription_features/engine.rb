module SubscriptionFeatures
  class Engine < Rails::Engine 
    isolate_namespace SubscriptionFeatures

    def self.table_name_prefix
      'magazine_'
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end 
end