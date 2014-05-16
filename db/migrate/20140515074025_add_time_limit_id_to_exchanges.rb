class AddTimeLimitIdToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :time_limit_id, :integer
  end
end
