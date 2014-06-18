describe Order do
  describe 'validation test' do
    it 'is valid with user and order_details' do
      order = build(:order, user_id: 1) {|order|
        order.order_details.build attributes_for(:order_detail, item_id: 1)
      }
      
      expect(order).to be_valid
    end

    it 'is invalid without order_details' do
      order = build(:order)
      expect(order).to be_invalid
    end
  end
end
