class DropProducts < ActiveRecord::Migration
   def up
    drop_table :admin_orders
   end
end
