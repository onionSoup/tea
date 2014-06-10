require 'rails_helper'

describe Order do
  describe 'association test' do
    it 'has many order_details' do
      association = Order.reflect_on_association(:order_details).macro
      expect(association).to eq(:has_many)
    end

    it 'belongs_to user' do
      association = Order.reflect_on_association(:user).macro
      expect(association).to eq(:belongs_to)
    end
  end

  describe 'validation test' do
    it 'is valid with user and order_details' do
      order = Order.new(user_id: 1)
      order.order_details.build(item_id: 1, quantity: 1, then_price: 100)
      expect(order).to be_valid
    end

    it 'is invalid without user' do
      order = Order.new
      order.order_details.build(item_id: 1, quantity: 1, then_price: 100)
      expect(order).to be_invalid
    end

    it 'is invalid without order_details' do
      order = Order.new(user_id: 1)
      expect(order).to be_invalid
    end
  end
end
