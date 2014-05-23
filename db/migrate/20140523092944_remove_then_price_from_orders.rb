class RemoveThenPriceFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :then_price, :integer
  end
end
