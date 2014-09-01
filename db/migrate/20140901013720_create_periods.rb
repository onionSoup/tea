class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.datetime :begin_time
      t.datetime :end_time
      t.integer  :state, default: 0

      t.timestamps
    end
  end
end
