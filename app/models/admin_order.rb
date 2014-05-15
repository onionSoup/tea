# == Schema Information
#
# Table name: admin_orders
#
#  id            :integer          not null, primary key
#  time_limit_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class AdminOrder < ActiveRecord::Base
  belongs_to :time_limit
end
