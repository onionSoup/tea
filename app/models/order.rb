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
  end
end
