module PaidUp
  # Unlimited class: designed to output as 'Unlimited' for string, -1 for db,
  # or 999999999 for number.
  module Unlimited
    def self.initialize
      999_999_999
    end

    def self.to_i(format = :default)
      format == :db ? -1 : 999_999_999
    end

    def self.to_s
      :unlimited.l
    end
  end
end
