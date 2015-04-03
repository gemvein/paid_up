class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.string :setting_type
      t.text :description
    end
    add_index :features, :name, :unique => true
  end
end
