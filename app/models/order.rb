# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  time_limit_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Order < ActiveRecord::Base
  has_many :order_details, dependent: :destroy
  belongs_to :user
  belongs_to :time_limit

  accepts_nested_attributes_for :order_details, reject_if: proc { |attributes| attributes['quantity'].to_i.zero? }
end
