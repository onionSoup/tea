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
  has_many :order_details, dependent: :destroy
  belongs_to :user

  scope :name_price_quantity_sum, ->(state_sym) {
    Order.method(state_sym).call.joins(order_details: :item).group('items.name','order_details.then_price').select('items.name, order_details.then_price, SUM(quantity)')
  }
  scope :this_state_orders_of_user, ->(user, state_sym) {
    user_id = user.id
    Order.method(state_sym).call.where(user_id: user_id)
  }

  enum state: [:registered, :ordered, :arrived, :exchanged]

  accepts_nested_attributes_for :order_details, reject_if: proc {|attributes| attributes['quantity'].to_i.zero? }

  class << self
    def price_sum_of_this_state_orders(state_sym)
      orders = Order.method(state_sym).call
      price_sum_of_orders(orders)
    end

    #ビューではこれが別途あったほうが便利。かもしれない。
    #ビューをモデルに合わせた方がいいかもしれない
    def price_sum_of_details(order)
      sum  = 0
      if order
        order.order_details.each do |detail|
          sum += detail.quantity * detail.then_price
        end
      end
      sum
    end

    #モデルでの重複を排除するために書いた
    def price_sum_of_orders(orders)
      sum  = 0
      if orders
        orders.each do |order|
          if order
            sum += price_sum_of_details(order)
          end
        end
      end
      sum
    end

    def before_state(state_string)
      states = [:registered, :ordered, :arrived, :exchanged]
      state_string = state_string.to_sym
      index = states.index(state_string)
      states[index -1]  if index
    end

    def price_sum_of_this_user(user, state_sym)
      orders = this_state_orders_of_user(user,state_sym)
      price_sum_of_orders(orders)
    end
  end
end
