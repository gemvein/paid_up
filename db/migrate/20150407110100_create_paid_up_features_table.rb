class CreatePaidUpFeaturesTable < ActiveRecord::Migration
  def change
    create_table :paid_up_features do |t|
      t.string :name
      t.string :setting_type
      t.text :description
    end
    add_index :paid_up_features, :name, :unique => true
  end
end
