class CreatePaidUpPlanFeatureSettingsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :paid_up_plan_feature_settings do |t|
      t.references :paid_up_plan, index: true, foreign_key: true
      t.string :feature, index: true, foreign_key: true
      t.integer :setting
    end
  end
end
