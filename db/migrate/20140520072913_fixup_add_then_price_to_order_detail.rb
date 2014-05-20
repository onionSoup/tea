require_relative '20140520064652_add_then_price_to_order_detail.rb'
class FixupAddThenPriceToOrderDetail < ActiveRecord::Migration
  def change
    revert AddThenPriceToOrderDetail
  end
end
