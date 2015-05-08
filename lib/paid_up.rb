module PaidUp
  require 'rails/all'
  require 'rails-i18n'
  require 'stripe' # Needs to be required before paid_up/stripe_extensions

  require 'paid_up/configuration'
  require 'paid_up/railtie'
  require 'paid_up/engine'
  require 'paid_up/localization'
  require 'paid_up/version'
  require 'paid_up/mixins'
  require 'paid_up/integer'
  require 'paid_up/stripe_extensions'

  require 'haml-rails'
  require 'bootswitch'
  require 'bootstrap_leather'
  require 'high_voltage'

  require 'devise'
  require 'cancan'

  require 'money'

  require 'seedbank'
  require 'chronic'
end