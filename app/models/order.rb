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

  accepts_nested_attributes_for :order_details, allow_destroy: true, reject_if: proc {|attributes| attributes['quantity'].to_i.zero? }

  validate do
    check_uniqueness_of_item_id_within_same_order
  end
  validates :user_id, presence: true

  scope :select_name_and_price_and_sum_of_quantity, -> {
    joins(order_details: :item).group('items.id', 'order_details.then_price').select('items.name, order_details.then_price, SUM(quantity) AS quantity')
  }

  enum state: [:registered, :ordered, :arrived, :exchanged]

  class << self
    def price_sum
      all.inject(0) {|acc, order| acc + order.order_details.price_sum }
    end
  end

  private

  #validates :item_id, uniqueness: {scope: :order}をvalidates_associated :order_details から呼ぶことで近いことはできる。しかしorder.id == nilの時validになる。そのため以下を用意。
  def check_uniqueness_of_item_id_within_same_order
    item_order_ids = order_details.map {|detail| [detail.item_id, self.id] }.sort
    duplication_counter = item_order_ids.size - item_order_ids.uniq.size
    errors.add :base, 'その商品は既に注文しています。' if duplication_counter.nonzero?
  end

  def create_another_order
    user.create_order
  end
end
