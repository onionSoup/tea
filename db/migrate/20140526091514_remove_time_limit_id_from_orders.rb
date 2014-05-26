class RemoveTimeLimitIdFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :time_limit_id, :integer
  end
end
