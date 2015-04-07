class CreatePaidUpPlansTable < ActiveRecord::Migration
  def change
    create_table :paid_up_plans do |t|
      t.decimal :charge
      t.string :period
      t.integer :cycles
      t.string :name
      t.text :description
      t.integer :sort

      t.timestamps
    end
    add_index :paid_up_plans, :name, :unique => true
  end
end