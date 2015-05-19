class AddStripeIdColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_id, :string, index: true
  end
end
