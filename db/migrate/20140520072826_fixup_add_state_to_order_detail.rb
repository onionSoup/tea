require_relative '20140520064739_add_state_to_order_detail.rb'
class FixupAddStateToOrderDetail < ActiveRecord::Migration
  def change
    revert AddStateToOrderDetail
  end
end
