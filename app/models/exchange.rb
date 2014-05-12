# == Schema Information
#
# Table name: exchanges
#
#  id            :integer          not null, primary key
#  order_id      :integer
#  exchange_flag :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

class Exchange < ActiveRecord::Base
  belongs_to :time_limit
  belongs_to :user
end
