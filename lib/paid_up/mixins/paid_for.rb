# frozen_string_literal: true

module PaidUp
  module Mixins
    ASSOCIATION_METHODS = {
      rolify_rows: :associations_for_rolify_rows,
      table_rows: :associations_for_table_rows,
      boolean: :true
    }.freeze

    # PaidFor Mixin
    module PaidFor
      extend ActiveSupport::Concern

      def paid_for(options = {})
        cattr_accessor :paid_for_scope_symbol # Creates class-level instance var

        extend ClassMethods
        include InstanceMethods

        self.paid_for_scope_symbol = options.fetch(:scope, :all)

        validate_feature
        associations
      end

      # Extended by paid_for mixin
      module ClassMethods
        def feature
          PaidUp::Feature.find_by_slug(table_name)
        end

        def paid_for_scope
          send(paid_for_scope_symbol)
        end

        private

        def validate_feature
          return true unless feature.nil?
          raise(:feature_not_found_feature.l(feature: table_name))
        end

        def associations
          setting_type = feature.setting_type
          method = ASSOCIATION_METHODS[setting_type.to_sym] ||
                   raise(
                     :value_is_not_a_valid_setting_type.l(value: setting_type)
                   )
          send(method)
        end

        def associations_for_rolify_rows
          resourcify
          attr_accessor :owner
        end

        def associations_for_table_rows
          belongs_to :user
          User.has_many table_name.to_sym
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
          self.class.where(id: owners_records_ids)
        end

        def owners_records_ids
          setting_type = self.class.feature.setting_type
          table_name = self.class.table_name
          owners.map do |subscriber|
            case setting_type
            when 'table_rows', 'rolify_rows'
              subscriber.send(setting_type, table_name).ids
            else
              raise :no_features_associated_with_table.l(table: table_name)
            end
          end.flatten
        end

        def owners_records_count
          owners_records.count
        end

        def enabled?
          if owners_enabled_count >= owners_records_count
            true
          else
            owners_records.order(id: :asc)
                          .limit(owners_enabled_count)
                          .include? self
          end
        end
      end
    end
  end
end
