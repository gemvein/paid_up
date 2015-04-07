# This migration comes from subscription_features (originally 20150406105900)
class CreateFeaturesPlansTable < ActiveRecord::Migration
  def change
    create_table :features_plans do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :plan, index: true, foreign_key: true
      t.integer :setting
    end
  end
end
