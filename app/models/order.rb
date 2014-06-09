# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :integer          default(0)
#

class Order < ActiveRecord::Base
  ORDER_DETAILS_COUNT_MIN = 1

  has_many :order_details, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :order_details, reject_if: proc {|attributes| attributes['quantity'].to_i.zero? }

  validate do
    check_order_details_number
  end

  scope :name_price_quantity_sum, -> {
    joins(order_details: :item).group('items.id', 'order_details.then_price').select('items.name, order_details.then_price, SUM(quantity) AS quantity')
  }
  scope :this_state_orders_of_user, ->(user, state_sym) {
    user_id = user.id
    Order.where(state: Order.states[state_sym], user_id: user_id)
  }

  enum state: [:registered, :ordered, :arrived, :exchanged]

  class << self
    def price_sum_of_this_state_orders(state_sym)
      orders = Order.where(state: Order.states[state_sym])
      price_sum_of_orders(orders) || 0
    end

    def price_sum_of_details(order)
      return 0 unless order

      #注文画面では、まだthen_priceは使えないため。
      order.order_details.inject(0) {|sum, d|
        price = d.then_price || d.item.price
        sum += d.quantity * price
      }
    end

    #モデルでの重複を排除するために書いた
    def price_sum_of_orders(orders)
      return 0 unless orders

      orders.map {|order| price_sum_of_details(order) }.inject(&:+)
    end

    def price_sum_of_this_user(user, state_sym)
      orders = this_state_orders_of_user(user,state_sym)
      price_sum_of_orders(orders)
    end
  end

  def price_sum_of_details
    return 0 unless self
    return 0 unless self.order_details
    #注文画面では、まだthen_priceは使えないため。
    self.order_details.inject(0) {|sum, d|
      price = d.then_price || d.item.price
      sum += d.quantity * price
    }
  end




  private
    def order_details_count_valid?
      order_details.reject(&:marked_for_destruction?).count >= ORDER_DETAILS_COUNT_MIN
    end

    def check_order_details_number
      unless order_details_count_valid?
        errors.add(:base, :order_details_too_short, :count => ORDER_DETAILS_COUNT_MIN)
      end
    end
end
