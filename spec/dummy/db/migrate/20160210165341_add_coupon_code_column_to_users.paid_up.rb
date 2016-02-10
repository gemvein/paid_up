# This migration comes from paid_up (originally 20160210165128)
class AddCouponCodeColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coupon_code, :string
  end
end
