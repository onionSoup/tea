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

  enum state: [:registered, :ordered, :arrived, :exchanged]

  class << self
    def price_sum
      all.inject(0) {|acc, order| acc + order.order_details.price_sum }
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
