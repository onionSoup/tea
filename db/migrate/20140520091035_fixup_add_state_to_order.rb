require_relative '20140520073738_add_state_to_order.rb'
class FixupAddStateToOrder < ActiveRecord::Migration
  def change
    revert AddStateToOrder
    add_column :orders, :state, :integer, default: 0
  end
end
