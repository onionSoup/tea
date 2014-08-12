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

  has_many :order_details, dependent: :destroy
  belongs_to :user

  after_destroy :create_another_order

  validates :user_id, presence: true

  scope :select_name_and_price_and_sum_of_quantity, -> {
    joins(order_details: :item).group('items.id', 'order_details.then_price').select('items.name, order_details.then_price, SUM(quantity) AS quantity')
  }

  enum state: [:registered, :ordered, :arrived, :exchanged]

  def registered?
    state == 'registered'
  end

  class << self
    def price_sum
      all.inject(0) {|acc, order| acc + order.order_details.price_sum }
    end
  end

  private

  def create_another_order
    user.create_order
  end
end
