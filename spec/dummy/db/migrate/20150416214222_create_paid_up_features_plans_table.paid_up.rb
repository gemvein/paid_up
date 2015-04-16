# This migration comes from paid_up (originally 20150407105900)
class CreatePaidUpFeaturesPlansTable < ActiveRecord::Migration
  def change
    create_table :paid_up_features_plans do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :plan, index: true, foreign_key: true
      t.integer :setting
    end
  end
end
