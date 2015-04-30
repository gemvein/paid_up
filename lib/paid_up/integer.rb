module PaidUp
  module Integer
    def to_date
      Time.at(self).strftime("%m/%d/%Y")
    end
  end
end

Integer.send(:include, PaidUp::Integer)