module PaidUp
  module Mixins
    # PaidFor Mixin
    module PaidFor
      extend ActiveSupport::Concern

      class_methods do
        attr_accessor :paid_for_scope_symbol # Creates class-level instance var

        def feature
          PaidUp::Feature.find_by_slug(table_name)
        end

        def paid_for_scope
          send(self.paid_for_scope_symbol)
        end

        def paid_for(options = {})
          self.paid_for_scope_symbol = options.fetch(:scope, :all)
          feature.nil? && raise(
            :feature_not_found_feature.l(feature: table_name)
          )
          case feature.setting_type
          when 'boolean'
            # Nothing needs doing
          when 'rolify_rows'
            resourcify
            attr_accessor :owner
          when 'table_rows'
            belongs_to :user
            User.has_many table_name.to_sym
          else
            raise(
              :value_is_not_a_valid_setting_type.l(
                value: feature.setting_type
              )
            )
          end

          send(:define_method, :owners) do
            case self.class.feature.setting_type
            when 'table_rows'
              [user]
            when 'rolify_rows'
              User.with_role(:owner, self)
            end
          end

          send(:define_method, :save_with_owner) do |owner|
            if save
              owner.add_role(:owner, self)
              self
            else
              false
            end
          end

          # How many records can this user have?
          send(:define_method, :owners_enabled_count) do
            setting = 0
            owners.each do |subscriber|
              setting += subscriber.plan.feature_setting(self.class.table_name)
            end
            setting
          end

          send(:define_method, :owners_records) do
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

          send(:define_method, :owners_records_count) do
            owners_records.count
          end

          send(:define_method, :enabled) do
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
end
