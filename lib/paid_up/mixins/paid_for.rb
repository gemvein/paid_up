module PaidUp::Mixins
  module PaidFor
    extend ActiveSupport::Concern
    class_methods do
      def feature
        PaidUp::Feature.find_by_slug(table_name)
      end
      def paid_for
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

        send(:define_method, :owners) do
          User.with_role(:owner, self)
        end

        send(:define_method, :save_with_owner) do |owner|
          result = save
          if result
            owner.add_role :owner, self
            result
          end
        end

        send(:define_method, :owners_enabled_count) do
          setting = 0
          for subscriber in owners
            setting += subscriber.plan.feature_setting(self.class.table_name)
          end
          setting
        end

        send(:define_method, :owners_records) do
          ids = []
          for subscriber in owners
            case self.class.feature.setting_type
              when 'table_rows'
                ids += subscriber.send(self.class.table_name).pluck(:id)
              when 'rolify_rows'
                ids += self.class.with_role(:owner, subscriber).pluck(:id)
              else
                raise :no_features_associated_with_table.l(table: self.class.table_name)
            end
          end
          self.class.where(id: ids)
        end

        send(:define_method, :owners_records_count) do
          owners_records.count
        end

        send(:define_method, :enabled) do
          if owners_enabled_count >= owners_records_count
            true
          else
            enabled_records = owners_records.order('created_at ASC').limit(owners_enabled_count)
            enabled_records.include? self
          end
        end
      end
    end
  end
end