module PaidUp
  module Unlimited
    def self.initialize
      999999999
    end
    def self.to_i(format = :default)
      if format == :db
        -1
      else
        999999999
      end
    end
    def self.to_s
      :unlimited.l
    end
  end
end