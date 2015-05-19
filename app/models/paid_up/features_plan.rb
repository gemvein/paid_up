class PaidUp::FeaturesPlan < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  belongs_to :feature, class_name: 'PaidUp::Feature'
  validates_presence_of :setting

  after_initialize :catch_unlimited_in_setting

  private
    def catch_unlimited_in_setting
      if setting == PaidUp::Unlimited.to_i(:db)
        self.setting = PaidUp::Unlimited
      end
    end
end