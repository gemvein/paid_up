module PaidUp
  module Mixins
    # PaidFor Mixin
    module PaidFor
      extend ActiveSupport::Concern

      def paid_for(options = {})
        cattr_accessor :paid_for_scope_symbol # Creates class-level instance var

        extend ClassMethods
        include InstanceMethods

        self.paid_for_scope_symbol = options.fetch(:scope, :all)
        feature.nil? && raise(
          :feature_not_found_feature.l(feature: table_name)
        )
        case feature.setting_type
        when 'rolify_rows'
          resourcify
          attr_accessor :owner
        when 'table_rows'
          belongs_to :user
          User.has_many table_name.to_sym
        else
          unless feature.setting_type == 'boolean'
            raise(
              :value_is_not_a_valid_setting_type.l(value: feature.setting_type)
            )
          end
        end
      end

      # Extended by paid_for mixin
      module ClassMethods
        def feature
          PaidUp::Feature.find_by_slug(table_name)
        end

        def paid_for_scope
          send(paid_for_scope_symbol)
        end
      end

      # Included by paid_for mixin
      module InstanceMethods
        def owners
          case self.class.feature.setting_type
          when 'table_rows'
            [user]
          when 'rolify_rows'
            User.with_role(:owner, self)
          end
        end

        def save_with_owner(owner)
          if save
            owner.add_role(:owner, self)
            self
          else
            false
          end
        end

        # How many records can this user have?
        def owners_enabled_count
          setting = 0
          owners.each do |subscriber|
            setting += subscriber.plan.feature_setting(self.class.table_name)
          end
          setting
        end

        def owners_records
          ids = []
          owners.each do |subscriber|
            case self.class.feature.setting_type
            when 'table_rows'
              ids += subscriber.send(self.class.table_name)
                               .paid_for_scope
                               .ids
            when 'rolify_rows'
              ids += self.class
                         .with_role(:owner, subscriber)
                         .paid_for_scope
                         .ids
            else
              raise(
                :no_features_associated_with_table.l(
                  table: self.class.table_name
                )
              )
            end
          end
          self.class.where(id: ids)
        end

        def owners_records_count
          owners_records.count
        end

        def enabled
          if owners_enabled_count >= owners_records_count
            true
          else
            enabled_records = owners_records.order('created_at ASC')
                                            .limit(owners_enabled_count)
            enabled_records.include? self
          end
        end
      end
    end
  end
end
