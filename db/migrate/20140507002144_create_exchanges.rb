class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :order_id
      t.boolean :exchange_flag

      t.timestamps
    end
  end
end
