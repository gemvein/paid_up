module PaidUp::Validators
  class TableRows < ActiveModel::Validator
    def validate(record)
      if record.send(options[:field]) == options[:comparison] && !ActiveRecord::Base.connection.table_exists?(record.send(options[:found_in]))
        record.errors[options[:found_in]] << :when_using_table_rows_table_must_exist.l
      end
    end
  end
end