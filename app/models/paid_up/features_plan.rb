class PaidUp::FeaturesPlan < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  belongs_to :feature, class_name: 'PaidUp::Feature'
  validates_presence_of :setting

  def unlimited?
    setting == -1
  end

  def self.find_by_feature_name(name)
    feature = PaidUp::Feature.find_by_name(name)

    if feature.nil?
      if feature.setting_type == 'boolean'
        false
      else
        nil
      end
    else
      find_by_feature_id(feature.id)
    end
  end
end