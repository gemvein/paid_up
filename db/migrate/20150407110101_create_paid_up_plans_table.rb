class CreatePaidUpPlansTable < ActiveRecord::Migration
  def change
    create_table :paid_up_plans do |t|
      t.string :stripe_id
      t.string :name
      t.text :description
      t.integer :sort

      t.timestamps
    end
    add_index :paid_up_plans, :name, :unique => true
    add_index :paid_up_plans, :stripe_id, :unique => true
  end
end