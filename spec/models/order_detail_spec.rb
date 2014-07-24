describe OrderDetail do
  #expectaitonにpriceがあり、assignもできないのでfixtures :itemsは使わない
  let!(:herb_tea) { create(:item, price: 100, name: "herb_tea") }
  let!(:red_tea)  { create(:item, price: 100, name: "red_tea" ) }

  describe '.price_sum' do
    it 'returns sum of each details' do
      create :order_detail, item: herb_tea, quantity: 1
      create :order_detail, item: red_tea, quantity: 2

      expect(OrderDetail.price_sum).to eq 300
    end
  end

  context 'when create a new order_detail' do
    it 'copies item.price to self.then_price' do
      detail_having_copy = create(:order_detail, item: herb_tea)

      expect(detail_having_copy.then_price).to eq 100
    end
  end
end
