class Feature < ActiveRecord::Base
  has_many :features_plans
  has_many :plans, :through => :features_plans

  validates_presence_of :name, :setting_type
end