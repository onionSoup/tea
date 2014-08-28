class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :user_id
      t.integer :quantity
      t.integer :then_price
      t.boolean :is_exchanged
      t.timestamps
    end
  end
end
