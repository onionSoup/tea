class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :time_limits_id

      t.timestamps
    end
  end
end
