# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  time_limit_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  state         :integer
#  then_price    :integer
#

class Order < ActiveRecord::Base
  has_many :order_details, dependent: :destroy
  belongs_to :user
  belongs_to :time_limit

  scope :user_order_table, -> {arrived arrived.joins(:user ,order: {order_detail: :item}) }

  enum state: [:registered, :ordered, :arrived, :exchanged]

  accepts_nested_attributes_for :order_details, reject_if: proc {|attributes| attributes['quantity'].to_i.zero? }

  class << self
    #引数を取るときはscopeよりクラスメソッドの方がpreferred way
    def name_price_quantity_sum(state_sym)
      Order.method(state_sym).call.joins(order_details: :item).group('items.id').select('items.name, items.price, SUM(quantity)')
    end

    def price_sum
      sum = 0
      Order.registered.each do |order|
        sum += Order.price_sum_of_this_order(order)
      end
      return sum
    end

    def price_sum_of_this_order(order)
      sum  = 0
      order.order_details.each do |detail|
        sum += detail.quantity * detail.item.price
      end
      return sum
    end

    #たぶんもっと良いやり方がある
    def before_state(state_string)
      case state_string.to_sym
      when :registered
        return :nil
      when :ordered
        return :registered
      when :arrived
        return :ordered
      when :exchanged
        return :arrived
      else
        return :nil
      end
    end
  end
end
