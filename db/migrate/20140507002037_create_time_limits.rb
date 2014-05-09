class CreateTimeLimits < ActiveRecord::Migration
  def change
    create_table :time_limits do |t|
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
