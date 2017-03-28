# frozen_string_literal: true
module PaidUp
  # PaidUp Controller
  class PaidUpController < ApplicationController
    helper :all

    before_action :set_locale
    before_action :warn_if_delinquent

    private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def warn_if_delinquent
      return unless delinquent? &&
                    params[:controller] != 'paid_up/subscriptions'
      flash[:error] = :account_is_delinquent.l +
                      :to_disable_this_message_subscribe.l(
                        subscribe_link: paid_up.plans_path
                      )
    end

    def delinquent?
      user_signed_in? && (
        current_user.plan.nil? ||
        current_user.stripe_data.delinquent
      )
    end
  end
end
