module PaidUp
  module PaidUpHelper
    def date_range(start_date, end_date)
      dates = []
      if start_date.present? && (start_date.is_a?(Date) || start_date.is_a?(Integer))
        dates << start_date.to_date
      end
      if end_date.present? && (end_date.is_a?(Date) || end_date.is_a?(Integer))
        dates << end_date.to_date
      end
      dates.join('&mdash;').html_safe
    end
  end
end