module PaidUp::Extensions
  module Integer
    def to_date
      Time.at(self).strftime("%m/%d/%Y")
    end
  end
end