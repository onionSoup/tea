class AddStateToOrderDetail < ActiveRecord::Migration
  def change
    add_column :order_details, :state, :integer
  end
end
