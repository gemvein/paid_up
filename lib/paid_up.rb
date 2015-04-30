module PaidUp
  require 'rails/all'
  require 'rails-i18n'

  require 'paid_up/configuration'
  require 'paid_up/railtie'
  require 'paid_up/engine'
  require 'paid_up/localization'
  require 'paid_up/version'
  require 'paid_up/mixins'
  require 'paid_up/integer'

  require 'haml-rails'
  require 'bootswitch'
  require 'bootstrap_leather'
  require 'high_voltage'

  require 'devise'
  require 'cancan'

  require 'stripe'

  require 'seedbank'
  require 'chronic'
end