module PaidUp
  class PaidUpController < ApplicationController
    helper :all

    before_action :set_locale
    before_action :set_current_subscriber

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def set_current_subscriber
      if defined? PaidUp.configuration.current_subscriber_method
        @current_subscriber = send(PaidUp.configuration.current_subscriber_method) || send(PaidUp.configuration.default_subscriber_method)
      else
        send(PaidUp.configuration.default_subscriber_method)
      end

    end
  end
end