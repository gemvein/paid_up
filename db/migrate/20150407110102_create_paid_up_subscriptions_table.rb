class CreatePaidUpSubscriptionsTable < ActiveRecord::Migration
  def change
    create_table :paid_up_subscriptions do |t|
      t.references :plan
      t.integer   :subscriber_id
      t.string    :subscriber_type
      t.datetime :valid_until

      t.timestamps
    end
    add_index :paid_up_subscriptions, :plan_id
    add_index :paid_up_subscriptions, :valid_until
    add_index :paid_up_subscriptions, [:subscriber_type, :subscriber_id], name: 'subscriber'
  end
end