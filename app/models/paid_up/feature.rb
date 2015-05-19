class PaidUp::Feature < ActiveRecord::Base
  has_many :features_plans, class_name: 'PaidUp::FeaturesPlan'
  has_many :plans, :through => :features_plans, class_name: 'PaidUp::Plan'

  validates_presence_of :name, :title, :setting_type

  validates_with PaidUp::TableValidator, field: 'setting_type', comparison: 'table_rows', found_in: 'name'

  def feature_model_name
    if setting_type != 'table_rows'
      raise :no_conversion_of_type_features_to_table_rows.l type: setting_type
    end
    name.classify
  end

  def feature_model
    feature_model_name.constantize
  end
end