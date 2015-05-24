class CreatePaidUpFeaturesPlansTable < ActiveRecord::Migration
  def change
    create_table :paid_up_features_plans do |t|
      t.references :plan, index: true, foreign_key: true
      t.string :feature, index: true, foreign_key: true
      t.integer :setting
    end
  end
end
