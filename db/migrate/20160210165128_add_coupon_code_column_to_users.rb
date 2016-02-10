class AddCouponCodeColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coupon_code, :string
  end
end
