module PaidUp
  class PaidUpController < ApplicationController
    before_action :set_locale
    before_action :set_current_subscriber

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def set_current_subscriber
      @current_subscriber = send(PaidUp.configuration.current_subscriber_method) || send(PaidUp.configuration.default_subscriber_method)
    end
  end
end