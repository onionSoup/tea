# == Schema Information
#
# Table name: order_details
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  item_id    :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#  then_price :integer
#

class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  before_create :copy_then_price

  validates :item_id, presence: true
  validates :quantity, presence: true
  validates :then_price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}


#これを保存するときに呼ぶ
  def copy_then_price
    self.then_price = item.price
  end

  class << self
    def price_sum
      all.inject(0) {|acc, detail|
        acc + detail.quantity * (detail.then_price || detail.item.price)
      }
    end
  end
end
