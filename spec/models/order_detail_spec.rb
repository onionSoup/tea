# == Schema Information
#
# Table name: order_details
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  item_id    :integer
#  quantity   :integer
#  then_price :integer
#  created_at :datetime
#  updated_at :datetime
#

#TO DO beforeやsubjectを使って書き直す
describe OrderDetail do
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
