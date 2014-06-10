require 'rails_helper'
describe OrderDetail do
  it 'is valid with item_id, quantity, and positive then_price' do
    detail = OrderDetail.new(item_id: 1, quantity: 1, then_price: 100)
    expect(detail).to be_valid
  end

  it 'is invalid without item_id' do
    detail = OrderDetail.new(quantity: 1, then_price: 100)
    expect(detail). to be_invalid
  end

  it 'is invalid without quantity' do
    detail = OrderDetail.new(item_id: 1, then_price: 100)
    expect(detail). to be_invalid
  end

  it 'is invalid with negative then_price' do
    detail = OrderDetail.new(item_id: 1, quantity: 1, then_price: -100)
    expect(detail). to be_invalid
  end
end
