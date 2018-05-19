class CreatePaidUpPlansTable < ActiveRecord::Migration[5.2]
  def change
    create_table :paid_up_plans do |t|
      t.string :stripe_id
      t.string :title
      t.text :description
      t.integer :sort_order

      t.timestamps
    end
    add_index :paid_up_plans, :title, unique: true
    add_index :paid_up_plans, :stripe_id, unique: true
  end
end
