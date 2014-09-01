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
  MAX_COUNT_OF_DETAILS = 25

  has_many   :order_details, dependent: :destroy
  belongs_to :user

  validates :user_id, presence: true

  enum state: %i(registered ordered arrived exchanged)

  def registered?
    state == 'registered'
  end

  def empty_order?
    return false unless state == 'registered'
    order_details.empty?
  end

  class << self
    def price_sum
      all.inject(0) {|acc, order| acc + order.order_details.price_sum }
    end

    def select_name_and_price_and_sum_of_quantity
      joins(order_details: :item).
        group('items.id', 'order_details.then_price').
          select('items.name, order_details.then_price, SUM(quantity) AS quantity')
    end

    def all_empty?
      all.all? {|order| order.empty_order? }
    end
  end
end
