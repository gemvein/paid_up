class PaidUp::FeaturesPlan < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  belongs_to :feature, class_name: 'PaidUp::Feature'
  validates_presence_of :setting
end