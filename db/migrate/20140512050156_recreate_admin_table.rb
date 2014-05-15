class RecreateAdminTable < ActiveRecord::Migration
  def change
    create_table :admin_orders do |t|
      t.integer :time_limit_id

      t.timestamps
   end
  end
end
