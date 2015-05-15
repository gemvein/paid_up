class PaidUp::Feature < ActiveRecord::Base
  has_many :features_plans, class_name: 'PaidUp::FeaturesPlan'
  has_many :plans, :through => :features_plans, class_name: 'PaidUp::Plan'

  validates_presence_of :name, :title, :setting_type
end