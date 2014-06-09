class RevertAdminOrdersExchangesTermsTimelimits < ActiveRecord::Migration
  def change
    revert do
      create_table :admin_orders do |t|
        t.integer  :time_limit_id
        t.datetime :created_at
        t.datetime :updated_at
        t.timestamps
      end
      create_table :exchanges do |t|
        t.boolean  :exchange_flag
        t.datetime :created_at
        t.datetime :updated_at
        t.integer  :time_limit_id
        t.timestamps
      end
      create_table :terms do |t|
        t.datetime :created_at
        t.datetime :updated_at
        t.datetime :beginning
        t.datetime :deadline
      end
      create_table :time_limits do |t|
        t.date     :start
        t.date     :end
        t.datetime :created_at
        t.datetime :updated_at
      end
    end
  end
end

