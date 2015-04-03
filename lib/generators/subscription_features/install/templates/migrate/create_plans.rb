class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.decimal :charge
      t.string :period
      t.integer :cycles
      t.string :name
      t.text :description
      t.integer :sort

      t.timestamps
    end
    add_index :plans, :name, :unique => true
  end
end