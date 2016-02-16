module PaidUp
  class PaidUpController < ApplicationController
    helper :all

    before_action :set_locale
    before_filter :warn_if_delinquent

  private
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def warn_if_delinquent
      if user_signed_in? && params[:controller] != 'paid_up/subscriptions'
        if current_user.plan.nil? || current_user.stripe_data.delinquent
          flash[:error] = :account_is_delinquent.l + :to_disable_this_message_subscribe.l(subscribe_link: paid_up.plans_path)
        end
      end
    end
  end
end