class CreateSubscriptionsTable < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :plan
      t.integer   :subscribing_id
      t.string    :subscribing_type
      t.datetime :charged_at

      t.timestamps
    end
    add_index :subscriptions, :plan_id
    add_index :subscriptions, [:subscribing_type, :subscribing_id]
  end
end