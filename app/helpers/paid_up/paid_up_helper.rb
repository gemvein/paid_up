# frozen_string_literal: true

module PaidUp
  # PaidUp PaidUp Helper
  module PaidUpHelper
    def date_range(start_date, end_date)
      dates = []
      dates << start_date.to_date if date_valid?(start_date)
      dates << end_date.to_date if date_valid?(end_date)
      dates.join('&mdash;').html_safe
    end

    def paid_up_google_analytics_data_layer
      render partial: 'paid_up/layouts/google_analytics_data_layer'
    end

    private

    def date_valid?(date)
      date.present? && (date.is_a?(Date) || date.is_a?(Integer))
    end
  end
end
