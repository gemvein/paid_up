# frozen_string_literal: true
module PaidUp
  module Validators
    # RolifyRows Validator
    class RolifyRows < ActiveModel::Validator
      def validate(record)
        found_in = options[:found_in]
        if record.send(options[:field]) == options[:comparison] &&
           !found_in_valid?(record, found_in)
          record.errors[found_in] << :when_using_rolify_rows_table_must_exist.l
        end
      end

      def found_in_valid?(record, found_in)
        ActiveRecord::Base.connection.data_source_exists?(
          record.send(found_in)
        )
      end
    end
  end
end
