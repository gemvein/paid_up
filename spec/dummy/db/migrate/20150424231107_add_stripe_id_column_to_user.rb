class AddStripeIdColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_id, :string
    add_index :users, :stripe_id
  end
end
