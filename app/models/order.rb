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
  #MAX_COUNT_OF_DETAILS = 25

  has_many :details, dependent: :destroy

  enum state: %i(preparing perchased arrived)

  def preparing?
    state == 'preparing'
  end

  #def registered?
   #state == 'registered'
  #end

  class << self
    #def price_sum
      #all.inject(0) {|acc, order| acc + order.details.price_sum }
    #end

    #def select_name_and_price_and_sum_of_quantity
      #joins(order_details: :item).
        #group('items.id', 'order_details.then_price').
          #select('items.name, order_details.then_price, SUM(quantity) AS quantity')
    #end

    def instantiate_order!
      Order.create(begin_time: Time.zone.now.beginning_of_month, 
                   end_time:   Time.zone.now.end_of_month)
    end

    def instantiate_if_no_order
      order = Order.order(:end_time).last

      return instantiate_order! unless order
      return instantiate_order! unless Time.zone.now.between? order.begin_time, order.end_time
    end

    def now_order
      order = Order.order(:end_time).last
      if Time.zone.now.between? order.begin_time, order.end_time
        order
      else
        raise 'latest order must have time in this month'
      end
    end
  end
end
