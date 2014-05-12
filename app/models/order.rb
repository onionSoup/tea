# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  time_limits_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Order < ActiveRecord::Base
  has_many :order_details
  belongs_to :user
end
