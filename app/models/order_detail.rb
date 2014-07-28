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
  MAX_NUMBER_OF_QUANTITY_OF_ONE_DETAIL = 20

  belongs_to :order
  belongs_to :item

  before_create :copy_then_price

  validates :item_id,
            presence: {message: 'お茶の名前を選択してください。' },
            uniqueness: {scope: :order, message: 'そのお茶は既に追加しています。'}
  validates :quantity,
            numericality: {only_integer: true, greater_than_or_equal_to: 0,
                           message: 'お茶の数量を選択してください。'}
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
