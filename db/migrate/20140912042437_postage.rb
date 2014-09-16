class Postage < ActiveRecord::Migration
  def change
    create_table :postages do |t|
      t.integer :border
      t.integer :cost
      t.timestamps
    end
  end
end
