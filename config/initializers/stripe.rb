# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(Rails.env.to_sym, :stripe, :publishable_key ) || ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: Rails.application.credentials.dig(Rails.env.to_sym, :stripe, :secret_key ) || ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

Stripe.set_app_info('Rails PaidUp', version: PaidUp::VERSION, url: 'https://www.gemvein.com/museum/cases/paid_up')

Money.rounding_mode = BigDecimal::ROUND_HALF_UP