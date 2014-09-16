# == Schema Information
#
# Table name: postages
#
#  id         :integer          not null, primary key
#  border     :integer
#  cost       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Postage < ActiveRecord::Base
  include PseudoSingleton
  before_create :must_be_singleton

  validates :border, presence:     true,
                     numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :cost,   presence:     true,
                     numericality: {only_integer: true, greater_than_or_equal_to: 0}

  class << self
    def postage_cost
      take.cost
    end

    def postage_border
      take.border
    end

    def cost_per_person
      cost = Postage.take.cost
      ordering_headcount = Order.count_of_non_empty_order
      ordering_headcount.zero? ? cost : cost / ordering_headcount
    end

    def cost_per_person_concern_free
      if free?
        0
      else
        cost_per_person
      end
    end

    def free?
      Order.price_sum >= take.border
    end
  end
end
