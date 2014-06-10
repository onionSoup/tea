class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.integer :nestle_index_from_the_top
      t.timestamps
    end
  end
end
