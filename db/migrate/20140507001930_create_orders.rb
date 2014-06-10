class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :state, default: 0
    end
  end
end
