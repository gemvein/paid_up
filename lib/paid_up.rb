# PaidUp Module
module PaidUp
  require 'active_record/railtie'
  require 'action_controller/railtie'
  require 'action_mailer/railtie'
  require 'action_view/railtie'
  require 'sprockets/railtie'

  require 'rails-i18n'

  require 'stripe' # Needs to be required before paid_up/stripe_extensions
  require 'devise' # Needs to be required before paid_up/mixins
  require 'cancan'
  require 'rolify'

  require 'paid_up/validators/table_rows'
  require 'paid_up/validators/rolify_rows'

  require 'paid_up/configuration'
  require 'paid_up/feature'
  require 'paid_up/railtie'
  require 'paid_up/engine'
  require 'paid_up/localization'
  require 'paid_up/version'

  require 'paid_up/extensions/stripe'
  require 'paid_up/extensions/integer'

  require 'paid_up/mixins/subscriber'
  require 'paid_up/mixins/paid_for'

  require 'haml-rails'
  require 'bootstrap_leather'

  require 'money'
  require 'chronic'
end

Integer.send(:include, PaidUp::Extensions::Integer)

Stripe::APIResource.send(:include, PaidUp::Extensions::Stripe)

ActiveRecord::Base.send(:extend, PaidUp::Mixins::Subscriber)
ActiveRecord::Base.send(:extend, PaidUp::Mixins::PaidFor)
