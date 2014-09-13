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
  include Status

  MAX_COUNT_OF_DETAILS = 25

  has_many   :order_details, dependent: :destroy
  belongs_to :user

  validate  do Period.singleton_instance.try(:valid?) end
  validate  :must_be_registered_when_period_has_undefined_times
  validate  :must_be_registered_when_period_has_times_include_now
  validate  :only_registered_order_allows_empty_detail
  validates :user_id, presence: true


  enum state: %i(registered ordered arrived exchanged)

  def registered?
    state == 'registered'
  end

  def not_registered?
    !registered?
  end

  def ordered?
    state == 'ordered'
  end

  def arrived?
    state == 'arrived'
  end

  def exchanged?
    state == 'exchanged'
  end

  def empty_order?
    #order_details.empty? をN+1対策しつつ書くのでこうなる。
    self.class.includes(:order_details).find(self).order_details.empty?
  end

  def non_empty_order?
    !empty_order?
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
      self.includes(:order_details).all? {|order| order.empty_order? }
    end

    def count_of_non_empty_order
      Order.all.count {|order| order.non_empty_order? }
    end
  end

  private
  def only_registered_order_allows_empty_detail
    return true if registered?

    if order_details.empty?
      errors[:base] << 'must have details unless registered'
    end
  end

  def must_be_registered_when_period_has_undefined_times
    return unless Period.singleton_instance
    return if Period.has_defined_times?

    errors[:base] << 'must have only registered when undefined period' if not_registered?
  end

  def must_be_registered_when_period_has_times_include_now
    return unless Period.singleton_instance
    return unless Period.include_now?

    errors[:base] << 'must have only registered when include_now period' if not_registered?
  end
end
