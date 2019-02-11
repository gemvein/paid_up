# frozen_string_literal: true

# PaidUp module
module PaidUp
  @feature_object = {}

  def self.add_feature(params)
    feature = PaidUp::Feature.new(params)
    @feature_object[feature.slug.to_sym] = feature
  end

  def self.features
    @feature_object
  end

  # Feature Class: Not an ActiveRecord object.
  class Feature
    include ActiveModel::Model
    include ActiveModel::AttributeMethods
    extend ActiveSupport::Concern

    attr_accessor :slug, :title, :setting_type, :description

    validates_presence_of :slug, :title, :setting_type
    validates(
      :setting_type,
      inclusion: { in: %w(boolean table_rows rolify_rows) }
    )
    validates_with(
      PaidUp::Validators::TableRows,
      field: 'setting_type',
      comparison: 'table_rows',
      found_in: 'slug'
    )
    validates_with(
      PaidUp::Validators::RolifyRows,
      field: 'setting_type',
      comparison: 'rolify_rows',
      found_in: 'slug'
    )

    class << self
      def raw
        PaidUp.features
      end

      def find_by_slug(slug)
        raw[slug.to_sym]
      end

      def find_by_slug!(slug)
        find_by_slug(slug) || raise(:feature_not_found.l)
      end

      def all
        raw.values
      end

      def find_all(**conditions)
        collection = []
        all.each do |feature|
          qualifies = true
          conditions.each do |key, value|
            feature.send(key) != value && (qualifies = false)
          end
          qualifies && collection << feature
        end
        collection
      end

      def find(**conditions)
        find_all(conditions).first
      end

      def method_missing(method_sym, *arguments, &block)
        if method_sym.to_s =~ /^find_by_(.*)$/
          find(Regexp.last_match[1].to_sym => arguments.first)
        elsif method_sym.to_s =~ /^find_all_by_(.*)$/
          find_all(Regexp.last_match[1].to_sym => arguments.first)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?('find_') || super
      end
    end

    def to_s
      slug
    end

    def feature_model_name
      acceptable_setting_types = %w(table_rows rolify_rows)
      unless acceptable_setting_types.include? setting_type
        raise :no_implicit_conversion_of_type_features.l(type: setting_type)
      end
      slug.classify
    end

    def feature_model
      feature_model_name.constantize
    end

    def for_graphql(setting)
      OpenStruct.new(
        id: slug,
        title: title,
        slug: slug,
        description: description,
        setting: setting,
        setting_human: setting_human(setting)
      )
    end

    def setting_human(setting)
      if setting == PaidUp::Unlimited.to_i
        PaidUp::Unlimited.to_s
      elsif setting_type == 'boolean'
        setting ? :allowed.l : :not_allowed.l
      else
        setting.to_s
      end
    end
  end
end
