class PaidUp::PlanFeatureSetting < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  validates_presence_of :setting, :plan, :feature

  after_initialize :catch_unlimited_in_setting

  private
    def catch_unlimited_in_setting
      if setting == PaidUp::Unlimited.to_i(:db)
        self.setting = PaidUp::Unlimited
      end
    end
end