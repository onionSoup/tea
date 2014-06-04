class AddNestleIndexFromTheTopToItems < ActiveRecord::Migration
  def change
    add_column :items, :nestle_index_from_the_top, :integer
  end
end
