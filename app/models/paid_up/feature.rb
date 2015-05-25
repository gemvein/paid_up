class PaidUp::Feature
  include ActiveModel::Model
  include ActiveModel::AttributeMethods

  @@instance_collector = []

  attr_accessor :slug, :title, :setting_type, :description

  validates_presence_of :slug, :title, :setting_type
  validates :setting_type, inclusion: { in: %w(boolean table_rows rolify_rows) }
  validates_with PaidUp::Validators::TableRows, field: 'setting_type', comparison: 'table_rows', found_in: 'slug'
  validates_with PaidUp::Validators::RolifyRows, field: 'setting_type', comparison: 'rolify_rows', found_in: 'slug'

  def initialize(attributes = {})
    super attributes
    @@instance_collector << self
  end

  def to_s
    slug
  end

  def feature_model_name
    acceptable_setting_types = ['table_rows', 'rolify_rows']
    unless acceptable_setting_types.include? setting_type
      raise :no_implicit_conversion_of_type_features.l(type: setting_type)
    end
    slug.classify
  end

  def feature_model
    feature_model_name.constantize
  end

  def self.all
    @@instance_collector
  end

  def self.find_all(**conditions)
    collection = []
    for feature in all
      qualifies = true
      conditions.each do |key, value|
        unless feature.send(key) == value
          qualifies = false
        end
      end
      if qualifies
        collection << feature
      end
    end
    collection
  end

  def self.find(**conditions)
    find_all(conditions).first
  end

  # Define on self, since it's  a class method
  def self.method_missing(method_sym, *arguments, &block)
    # the first argument is a Symbol, so you need to_s it if you want to pattern match
    if method_sym.to_s =~ /^find_by_(.*)$/
      self.find($1.to_sym => arguments.first)
    elsif method_sym.to_s =~ /^find_all_by_(.*)$/
      self.find_all($1.to_sym => arguments.first)
    else
      super
    end
  end

  def self.respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('find_') || super
  end

end