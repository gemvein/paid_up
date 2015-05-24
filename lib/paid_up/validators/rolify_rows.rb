module PaidUp::Validators
  class RolifyRows < ActiveModel::Validator
    def validate(record)
      if record.send(options[:field]) == options[:comparison] && !ActiveRecord::Base.connection.table_exists?(record.send(options[:found_in]))
        record.errors[options[:found_in]] << :when_using_rolify_rows_table_must_exist.l
      end
    end
  end
end