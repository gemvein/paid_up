class CreateSubscriptionsTable < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :plan
      t.integer   :subscriber_id
      t.string    :subscriber_type
      t.datetime :charged_at

      t.timestamps
    end
    add_index :subscriptions, :plan_id
    add_index :subscriptions, [:subscriber_type, :subscriber_id]
  end
end