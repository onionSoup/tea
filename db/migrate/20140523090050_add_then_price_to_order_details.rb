class AddThenPriceToOrderDetails < ActiveRecord::Migration
  def change
    add_column :order_details, :then_price, :integer
  end
end
