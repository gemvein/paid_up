module PaidUp
  class Engine < Rails::Engine
    isolate_namespace PaidUp
    engine_name "paid_up"

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    def self.table_name_prefix
      'paid_up_'
    end
  end 
end