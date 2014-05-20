class AddStateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :state, :integer
  end
end
