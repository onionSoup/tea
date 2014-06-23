describe Order do
  it 'is valid with user and order_details' do
    order = build(:order, user_id: 1) {|order|
      order.order_details.build attributes_for(:order_detail, item_id: 1)
    }

    expect(order).to be_valid
  end

  it 'is valid without order_details' do
    order = build(:order)
    expect(order).to be_valid
  end

  context 'when there is same item' do
    it 'is invalid with order_details of same item' do
      item = create(:item)
      order = build(:order,
        order_details: [
          build(:order_detail, item: item),
          build(:order_detail, item: item)
        ]
      )
      expect(order).to be_invalid
      expect(order.errors.messages[:base].join).to match /order_details_must_have_unique_item_within_same_order/
    end

    it 'is valid with two orders of same item' do
      alice = create(:user, name: 'Alice')
      bob = create(:user, name: 'Bob')
      same_item = create(:item)

      alice.order = build(:plain_order, order_details: [build(:order_detail, item: same_item)])
      bob.order = build(:plain_order, order_details: [build(:order_detail, item: same_item)])

      expect(alice.order).to be_valid
      expect(bob.order).to be_valid
    end
  end

  context 'when destroy' do
    it 'should create new order after destroy order' do
      alice = create(:user, name: 'Alice')
      item = create(:item)
      alice.order.order_details << OrderDetail.new(item: item, quantity: 1)

      Order.find(alice.order).destroy
      order_of_alice = User.find(alice).order
      expect(order_of_alice.order_details).to eq([])
    end
  end
end
