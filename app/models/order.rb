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

  scope :name_price_quantity_sum, ->(state_sym) {
    Order.where(state: Order.states[state_sym]).joins(order_details: :item).group('items.name','order_details.then_price').select('items.name, order_details.then_price, SUM(quantity)')
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
      order.order_details.map {|d|
        d.then_price ? d.quantity * d.then_price : d.quantity * d.item.price
      }.inject(&:+)
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
