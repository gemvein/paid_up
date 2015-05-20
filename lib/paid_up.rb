module PaidUp
  require 'rails/all'
  require 'rails-i18n'
  require 'stripe' # Needs to be required before paid_up/stripe_extensions
  require 'devise' # Needs to be required before paid_up/mixins

  require 'paid_up/configuration'
  require 'paid_up/railtie'
  require 'paid_up/engine'
  require 'paid_up/localization'
  require 'paid_up/version'
  require 'paid_up/stripe_extensions'
  require 'paid_up/unlimited'
  require 'paid_up/mixins'
  require 'paid_up/integer'
  require 'paid_up/table_validator'

  require 'haml-rails'
  require 'bootstrap_leather'
  require 'cancan'

  require 'money'

  require 'seedbank'
  require 'chronic'
end