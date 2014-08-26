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

class Detail < ActiveRecord::Base
  MAX_QUANTITY_PER_ORDER = 20

  belongs_to :order
  belongs_to :user
  belongs_to :item

  before_create :copy_then_price

  validates :item_id,  presence: true#, uniqueness: {scope: :order}
  validates :quantity, numericality: {only_integer: true, greater_than_or_equal_to: 0}

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