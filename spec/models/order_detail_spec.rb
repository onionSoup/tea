describe OrderDetail do
  describe '.price_sum' do
    it 'returns sum of each details' do
      item = create(:item, price: 100)
      create :order_detail, item_id: item.id, quantity: 1
      create :order_detail, item_id: item.id, quantity: 2
      expect(OrderDetail.price_sum).to eq 300
    end
  end

  context 'when create a new order_detail' do
    it 'copies item.price to self.then_price' do
      item = create(:item, price: 100)
      detail_having_copy = create(:order_detail, item_id: item.id, quantity: 1)
      expect(detail_having_copy.then_price).to eq 100
    end
  end
end
