class AddThenPriceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :then_price, :integer
  end
end
