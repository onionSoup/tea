class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer  :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer  :state, default: 0
      t.timestamps
    end
  end
end
