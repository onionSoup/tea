class RenameTimeLimitsToTimeLimit < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.rename  :time_limits_id, :time_limit_id
    end
  end
end
