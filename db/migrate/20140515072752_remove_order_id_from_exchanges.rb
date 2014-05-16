class RemoveOrderIdFromExchanges < ActiveRecord::Migration
  def change
    remove_column :exchanges, :order_id, :integer
  end
end
