module PaidUp::Mixins
  module PaidFor
    extend ActiveSupport::Concern
    class_methods do
      def paid_for
        feature = PaidUp::Feature.find_by_slug(table_name)
        if feature.nil?
          raise :feature_not_found_feature.l feature: table_name
        else
          case feature.setting_type
            when 'boolean'
              # Nothing needs doing
            when 'rolify_rows'
              resourcify
            when 'table_rows'
              belongs_to :user
            else
              raise :value_is_not_a_valid_setting_type.l(value: feature.setting_type)
          end
        end
      end
    end
  end
end