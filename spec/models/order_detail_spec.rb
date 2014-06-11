#TO DO beforeやsubjectを使って書き直す
describe OrderDetail do
  describe 'association test' do
    it 'belongs_to item' do
      association = OrderDetail.reflect_on_association(:item).macro
      expect(association).to eq(:belongs_to)
    end

    it 'belongs_to order' do
      association = OrderDetail.reflect_on_association(:order).macro
      expect(association).to eq(:belongs_to)
    end
  end

  describe 'validation test' do
    it 'is valid with item_id, quantity, and positive then_price' do
      detail = OrderDetail.new(item_id: 1, quantity: 1, then_price: 100)
      expect(detail).to be_valid
    end

    it 'is invalid without item_id' do
      detail = OrderDetail.new(quantity: 1, then_price: 100)
      expect(detail).to be_invalid
    end

    it 'is invalid without quantity' do
      detail = OrderDetail.new(item_id: 1, then_price: 100)
      expect(detail).to be_invalid
    end
  end

  describe '.price_sum' do
    it 'returns sum of each details' do
      @details = []
      Item.create(id: 1, name: 'tea', price: 100)
      @details << OrderDetail.create(item_id: 1, quantity: 1)
      @details << OrderDetail.create(item_id: 1, quantity: 2)
      expect(OrderDetail.price_sum).to eq(300)
    end
  end

  describe '.copy_then_price' do
    it 'copy item.price to detail.then_price' do
      Item.create(id: 1, name: 'tea', price: 100)
      copy_taget = OrderDetail.create(item_id: 1, quantity: 1)
      expect(copy_taget.then_price).to eq(100)
    end
  end
end
