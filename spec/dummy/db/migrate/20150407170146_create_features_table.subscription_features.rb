# This migration comes from subscription_features (originally 20150406110100)
class CreateFeaturesTable < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.string :setting_type
      t.text :description
    end
    add_index :features, :name, :unique => true
  end
end
